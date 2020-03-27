class Semtag < Formula
  desc "Semantic tagging script for git"
  homepage "https://github.com/pnikosis/semtag"
  url "https://github.com/pnikosis/semtag/archive/v0.1.0.tar.gz"
  sha256 "9e16a418b795363a9283318e5dc02da8a67ec96adaac0ae8eb23f1b21b06666f"

  bottle :unneeded

  def install
    bin.install "semtag"
  end

  test do
    touch "file.txt"
    system "git", "init"
    system "git", "add", "file.txt"
    system "git", "commit", "-m'test'"
    system bin/"semtag", "final"
    output = shell_output("git tag --list")
    assert_match "v0.0.1", output
  end
end
