class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.5.tar.gz"
  sha256 "2bfdb6315f13bd503095aaf301fa0407a6b3fba279739783c48ab093b8ec146c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bba82208e7ab1f5966bb67c5f13867616e3547ba5517c62d69f9539b143efab1"
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
