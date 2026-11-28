class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.9.tar.gz"
  sha256 "f93d9d4bb0d6fd676704e45733190413885c859ff2807b84cc8113bf674fc063"
  license "MIT"

  bottle do
    manifest_sha256 "110006f5f5d4367d3f36af761e10eb59b98dc60293042b1474d24a0e9d4148e3"
    sha256 cellar: :any_skip_relocation, all: "5d2cbe4ed925006cc99467b8a4b837b75e60a2381641b15471fd71a08d0d2b5d"
  end

  depends_on "fzf"

  on_macos do
    depends_on "bash"
  end

  conflicts_with "git-extras", because: "both install `git-undo` binaries"

  deny_network_access!

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version #{version}", shell_output("#{bin}/ugit --version")
    assert_match "Ummm, you are not inside a Git repo", shell_output(bin/"ugit")
  end
end
