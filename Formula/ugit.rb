class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.1.tar.gz"
  sha256 "52e72f9d44c3160987cdc0a393ccce3c0c76e76aa6b3e792e4b7ef2891a2b09d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60defa582e785947c52c9489f03d5834e6e83853612e221c2869630c7621643a"
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
