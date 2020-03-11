class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman",
      :using    => :git,
      :tag      => "v1.1.0",
      :revision => "6171942938e92803c54309b3098cf662411a4f1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "344233881bf3a42e7ce547852bd9e96c88dc3c5aadbb0c05de4fe1766cb2b64b" => :catalina
    sha256 "d59d5b2cf4d8ab5aa5dfd03f5be19ed9fefdf0440b8d8fecf4f4b76f8bb37e8f" => :mojave
    sha256 "172d14b6bdf44cba89030586816a74c4f5b6646ef546d02fa06202b7d85572cf" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    system "./build"
    bin.install "./talisman_darwin_amd64" => "talisman"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
