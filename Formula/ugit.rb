class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.4.tar.gz"
  sha256 "6e1fd740ad5dfe1e31126178df9ab86c32d081169f9dbbd40da2147e3c588554"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbca08614a3794ba4002544c8ca2c7fe5d28e66282b580a7f69b957071e24615"
  end

  depends_on "bash"
  depends_on "fzf"

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version #{version}", shell_output("#{bin}/ugit --version")
    assert_match "Ummm, you are not inside a Git repo", shell_output("#{bin}/ugit")
  end
end
