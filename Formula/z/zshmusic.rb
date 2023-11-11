class Zshmusic < Formula
  desc "A cli tool to control Apple Music"
  homepage "https://github.com/codingMustache/zshMusic"
  url "https://github.com/codingMustache/zshMusic/archive/refs/tags/v1.2.tar.gz"
  sha256 "1f5db297ccc97d8672928c21a4164ea0d0839c8b2b0ed54f763335aea25bb49e"
  license "MIT"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      To activate the autosuggestions, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zshmusic/zshmusic.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    system "#{bin}/zshmusic", "--help"
  end
end
