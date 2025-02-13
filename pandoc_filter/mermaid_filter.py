import panflute as pf


def mermaid_filter(element, doc):
    if isinstance(element, pf.CodeBlock) and "mermaid" in element.classes:
        # Prepare the text to be HTML friendly, converting special HTML characters
        # This should maintain newlines
        html_text = pf.stringify(element, newlines=True)

        # Encapsulate the Mermaid diagram in a div with class "mermaid"
        raw_html = f'<div class="mermaid">\n{html_text}\n</div>'

        # Return as a raw block that will not be processed further by Pandoc
        return pf.RawBlock(raw_html, format="html")


def main(doc=None):
    return pf.run_filter(mermaid_filter, doc=doc)


if __name__ == "__main__":
    main()
