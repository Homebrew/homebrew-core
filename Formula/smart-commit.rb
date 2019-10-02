class SmartCommit < Formula
  desc "Commit with current branch name"
  homepage "https://github.com/sbimochan/smart-commit"
  url "https://github.com/sbimochan/smart-commit/archive/v2.0.tar.gz"
  sha256 "468afe13dd5d09ff149f62f128acc44aaff8a59020ae7d34f30360dbbeacab3f"

  def install
    bin.install("commit")
  end

  test do
    system "mkdir test_repo; cd test_repo"
    system "git", "init"
    system "git", "checkout", " -b", "EF-123"
    touch "testfile.md"
    system "git", "add", "."
    output = shell_output("#{bin}/commit 'Add test file'")
    assert_match "EF-123: Add test file", output
  end
end
