class Ugit < Formula
  desc "🚨️ ugit helps you undo git commands. Your damage control git buddy"
  homepage "https://github.com/Bhupesh-V/ugit"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.0.tar.gz"
  sha256 "f1d603756635675b557cb43eda01443b87f5024aab455283f06a3fd9cfbf2d06"
  license "MIT"

  depends_on "bash"
  depends_on "fzf"

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version", shell_output("#{bin}/ugit --version")
    assert_match "ugit help", shell_output("#{bin}/ugit --help")
  end
end
