class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma.github.io/zinit/wiki/"
  url "https://github.com/zdharma/zinit/archive/refs/tags/v3.7.tar.gz"
  sha256 "dcd7ded70255a576a4612edb743650f83e688bd4a4b473bbdafeddb473bde3c9"
  license "MIT"
  head "https://github.com/zdharma/zinit.git"

  bottle :unneeded

  uses_from_macos "zsh"

  def install
    man1.install "doc/zinit.1"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end
