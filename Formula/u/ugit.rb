class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.8.tar.gz"
  sha256 "aedc5fd10b82ed8f3c2fc3ffb9d912863a7fec936a9e444a25e8a41123e2e90f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11a2937a45b7f145b2cebf6603f0534924afa2e4fa33116728f44afb1ece9968"
  end

  depends_on "bash"
  depends_on "fzf"

  conflicts_with "git-extras", because: "both install `git-undo` binaries"

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version #{version}", shell_output("#{bin}/ugit --version")
    assert_match "Ummm, you are not inside a Git repo", shell_output(bin/"ugit")
  end
end
