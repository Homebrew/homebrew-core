class QwertyFr < Formula
  desc "Qwerty keyboard layout with French accents"
  homepage "https://qwerty-fr.org"
  url "https://github.com/qwerty-fr/qwerty-fr/releases/download/v0.7/qwerty-fr_0.7_mac.zip"
  sha256 "34bc8c8f764798ed7e48a3f2404319e09a6d8bfcbef350b25df32387a3199bfa"
  license "MIT"

  def install
    # Homebrew automatically extracts the folder inside the archive to the cur directory (not configurable)
    # so we need to rebundle it
    mkdir "qwerty-fr.bundle"
    mv "Contents", "qwerty-fr.bundle/"
    prefix.install "qwerty-fr.bundle"
  end

  def caveats
    <<~EOS
      1) Finishing the installation

        To globally install the layout, you need to manually link the layout bundle (only once):
          sudo ln -sf '#{prefix}/qwerty-fr.bundle' '/Library/Keyboard Layouts/'

        If you only want to only install the layout for the current user, do the following instead:
          ln -sf '#{prefix}/qwerty-fr.bundle' '~/Library/Keyboard Layouts/'


      2) Restart your system (dead keys don't work properly before restarting).


      3) You can then enable the qwerty-fr layout by doing the following:
          a) Open "System Preferences" → "Keyboard" → "Input Source".
          b) Click on "+" → Search for "qwerty-fr" → Click on "Add".
          c) Click on the layout selection icon in the menu bar of macOS and choose "qwerty-fr"
    EOS
  end

  test do
    system "true"
  end
end
