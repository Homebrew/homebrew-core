class Ttab < Formula
  desc "CLI for opening a new terminal tab/window"
  homepage "https://github.com/mklement0/ttab"
  url "https://github.com/mklement0/ttab/archive/v0.6.1.tar.gz"
  sha256 "5ccfb01c8798bcc78de09ffaeb586eddd5b93166ddf6101167ac9b3202c6e5e1"

  def install
    bin.install "bin/ttab"
  end

  test do
    actual_output = `#{bin}/ttab --dry-run ls`
    expected_output = <<~EOS
      tell application "Terminal"
        if not frontmost then
        activate
        repeat until frontmost
            delay 0.1
        end repeat
      end if
        
        tell application "System Events" to tell menu 1 of menu item 2 of menu 1 of menu bar item 3 of menu bar 1 of application process "Terminal" to click (first menu item whose value of attribute "AXMenuItemCmdChar" is "T" and value of attribute "AXMenuItemCmdModifiers" is 0)
        set newTab to selected tab of front window
        
        do script " ls" in newTab
        
      end tell
      
      return
    EOS
    assert_equal(expected_output.strip, actual_output.strip)
  end
end
