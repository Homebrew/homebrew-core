class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman",
      :using    => :git,
      :tag      => "v1.3.0",
      :revision => "01d957c30db6a1db844627b447a96887b53f4032"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eb4f610bb1a9df059215ff73b7824e41843d4533f7c7fb0c54a63955bacb36f" => :catalina
    sha256 "226b694a1e3619ec361fd49be1f502e7608fa6cef23c0ffaa1eedeff93131173" => :mojave
    sha256 "953b5dfcb93d7344444460d695dbaba06f928194307d7bd43b17ecbf2f53618c" => :high_sierra
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
