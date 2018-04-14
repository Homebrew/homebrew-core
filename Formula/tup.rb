class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.6.tar.gz"
  sha256 "db8832cf31e9776ea432fe1f9747f6aba6e3d7308331d44c55601e7bec6ab5c6"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha256 "057ef3d3629344c3553a529b1b1e7d9e62d92acfd8f006501ef49d4407e3efa7" => :high_sierra
    sha256 "7cac0f32fced84617e15c3684502089d972be91ed5bcebe3fb382ae1ac4d8762" => :sierra
    sha256 "fdd04fc05f339b5d87ecb77838538f80bf7f0343be020037feb7101a1966c953" => :el_capitan
    sha256 "6c898724dee0ed50fda5900ff95957feae31673f8b59c7d58e1a988fbd132a8d" => :yosemite
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
