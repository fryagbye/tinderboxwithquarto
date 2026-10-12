#!/usr/bin/env python3
"""Audit user-defined attributes in a Tinderbox .tbx document.

Classifies every `parent="User"` attribute by evidence of usage:

  strong  - referenced by code/templates ($Name, attribute(), dict lines),
            DisplayedAttributes lists, attribute defaults (dictionary values
            like GG_Attributes), TableAttributes lists, or repository files
  weak    - has a stored value on some note but no reader found
  none    - no evidence at all (deletion candidate)

Usage: python3 audit_attributes.py [path.tbx]
Output: JSON to stdout (also written beside this script).
"""
import re, html, json, os, sys, collections

TBX = sys.argv[1] if len(sys.argv) > 1 else 'Demo_TBX_for_Quarto.tbx'
REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SKIP_DIRS = {'.git', 'output', '.venv', '.quarto', 'renv', 'node_modules'}
SCAN_EXT = ('.tbxa', '.tbxe', '.html', '.py', '.sh', '.applescript', '.js',
            '.qmd', '.yml', '.yaml')
CODE_ATTRS = {
    'OnAdd', 'Rule', 'Edict', 'AgentQuery', 'AgentAction', 'TableExpression',
    'DisplayExpression', 'HoverExpression', 'Sort', 'SortAlso', 'SortTransform',
    'OnRemove', 'OnVisit', 'OnDelete', 'InspectorExpression',
    'DisplayedAttributesExpression', 'HTMLExportTemplate', 'HTMLExportFileName',
    'HTMLExportExtension'}
FUNC_LISTS = {'TableAttributes'}  # list attrs whose members drive behaviour
DEBUG_LISTS = {'MyList', 'MyDictionary'}  # debug dumps; names here aren't usage


def main():
    xml = open(os.path.join(REPO, TBX), encoding='utf-8', errors='replace').read()
    attrs = re.findall(r'<attrib Name="([^"]+)"[^>]*parent="User"', xml)
    attrset = set(attrs)

    disp, code, valueset, funclist, dictline = set(), set(), set(), set(), set()
    src = collections.defaultdict(set)

    def scan_code(val, tag):
        for m in re.finditer(r'\$([A-Za-z_][A-Za-z0-9_]*)\s*(?=[\(\[=;,.\s\)\]\+\'\":\}]|$)', val):
            if m.group(1) in attrset:
                code.add(m.group(1)); src[m.group(1)].add(tag)
        for m in re.finditer(r"attribute\((?:'|\")([A-Za-z_][A-Za-z0-9_]*)(?:'|\")\)", val):
            if m.group(1) in attrset:
                code.add(m.group(1)); src[m.group(1)].add('attribute()')
        for m in re.finditer(r'([A-Za-z_][A-Za-z0-9_]*):\{create:', val):
            if m.group(1) in attrset:
                dictline.add(m.group(1)); code.add(m.group(1)); src[m.group(1)].add('dict-line')

    # attribute definitions: default/suggested may hold dictionaries of $Name refs
    for m in re.finditer(r'<attrib Name="[^"]+"[^>]*>', xml):
        for kv in re.finditer(r'(default|suggested)="(.*?)"', m.group(0)):
            scan_code(html.unescape(kv.group(2)), 'attribdef:' + kv.group(1))

    # per-note attribute values
    for m in re.finditer(r'<attribute name="([^"]+)"[^>]*>(.*?)</attribute>', xml, re.S):
        name, val = m.group(1), html.unescape(m.group(2))
        if name == 'DisplayedAttributes':
            disp |= {t.strip() for t in val.split(';') if t.strip() in attrset}
        elif name in CODE_ATTRS:
            scan_code(val, name)
        else:
            scan_code(val, 'valstr:' + name)  # dictionaries/eval strings
            if name in attrset and val.strip():
                valueset.add(name)
            if name in FUNC_LISTS:
                funclist |= {t.strip() for t in val.split(';') if t.strip() in attrset}

    # note text and rich-text bodies (export templates live in <text>)
    for m in re.finditer(r'<(text|html)[^>]*>(.*?)</\1>', xml, re.S):
        val = html.unescape(m.group(2))
        if '$' in val:
            scan_code(val, m.group(1))

    # repository files
    pat = re.compile(r'\$(' + '|'.join(re.escape(a) for a in
                     sorted(attrs, key=len, reverse=True)) + r')(?=[\(\[=;,.\s\)\'\"]|$)')
    for root, dirs, files in os.walk(REPO):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for f in files:
            if f.endswith(SCAN_EXT):
                try:
                    txt = open(os.path.join(root, f), encoding='utf-8', errors='replace').read()
                except OSError:
                    continue
                for m in pat.finditer(txt):
                    code.add(m.group(1)); src[m.group(1)].add('repo')

    strong = code | disp | funclist
    weak = valueset - strong
    none = [a for a in attrs if a not in strong and a not in valueset]

    result = {
        'document': TBX,
        'total': len(attrs),
        'strong': sorted(strong),
        'weak': sorted(weak),
        'none': sorted(none),
        'evidence': {a: sorted(src.get(a, [])) for a in attrs},
    }
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                       'evidence-' + os.path.splitext(TBX)[0] + '.json')
    with open(out, 'w') as f:
        json.dump(result, f, indent=1)
    print(f"{TBX}: total={len(attrs)} strong={len(strong)} "
          f"weak={len(weak)} none={len(none)} -> {out}")


if __name__ == '__main__':
    main()
