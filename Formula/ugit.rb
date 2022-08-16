class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.2.tar.gz"
  sha256 "0eb27258cec03ee569bf564016a277548774cf9460eb2c1c63f675b80c7a1fb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6f5e1b00f3a4c3228dfb5615b5a23c1f2be8b95d84a2aad6b1b42fe903d9ab2"
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
