class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.7.tar.gz"
  sha256 "0ccf6c11d1dc6ec2e2bdd740487c291a03b842f5453bf833bff97e34c1ea2632"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha256 "6faeb45a89831da4c11d49738b9c000c1379ff394ff078b594c47165a80c0ee0" => :mojave
    sha256 "830062df2cda63864ade8c15667a239216a9a2bdc318bd1df9665075834a9968" => :high_sierra
    sha256 "3df4d4ca62f3997058093bc2c019224a4dd24ece381a8a8010ea6098c31f9ba0" => :sierra
    sha256 "7549fb6a80aa8a9e7bf8e1c9a83e333c903f2911578728ecaaa3f71f50d7b135" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
    doc.install (buildpath/"docs").children
    pkgshare.install "contrib/syntax"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
