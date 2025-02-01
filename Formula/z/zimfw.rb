class Zimfw < Formula
  desc "Zsh plugin manager"
  homepage "https://zimfw.sh"
  url "https://github.com/zimfw/zimfw/releases/download/v1.17.0/zimfw.zsh.gz"
  sha256 "31fa45e3f2d486d2f51de190b32280c0b4adad0b26673b8aac63ddf371eefd78"
  license "MIT"

  uses_from_macos "zsh" => :test

  def install
    share.install "zimfw.zsh"
  end

  def caveats
    <<~EOS
      To finish the set up, see:
        https://github.com/zimfw/zimfw#homebrew

      Source from #{opt_share}/zimfw.zsh in your .zshrc.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c 'source #{share}/zimfw.zsh version'")
  end
end
