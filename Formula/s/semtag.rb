class Semtag < Formula
  desc "Semantic tagging script for git"
  homepage "https://github.com/nico2sh/semtag"
  url "https://github.com/nico2sh/semtag/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "37890fc5bbdeba923b51ff615c4e99b002c95d922925ed1efefd117ad7934548"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "3d514ee9de7b9214e67c393d2e1ee99f3327cbc7df8a0cbc82c9ec5a956dd965"
    sha256 cellar: :any_skip_relocation, all: "604f7f8fae481b73da08c4c4465852d2b955954df5401961bd4a2c16ad7918af"
  end

  on_macos do
    depends_on "bash" # Needs Bash 4.x>
  end

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
