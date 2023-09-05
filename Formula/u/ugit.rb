class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.6.tar.gz"
  sha256 "6e7ecab2a6d610f52a1e4382ec8310cb05000b593fa71f3b81dbcb39d8e0de88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d30a7f5227f7c642490e807512fbb5cc7d1c32f6c926b899b77b78322d538d13"
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
