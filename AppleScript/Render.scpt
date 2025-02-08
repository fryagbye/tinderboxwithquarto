tell application "Terminal"
  activate
  set currentTab to do script "cd ~/github/tinderboxwithquarto"
  delay 0.3
  do script "/usr/local/bin/quarto render index.qmd " in currentTab
end tell