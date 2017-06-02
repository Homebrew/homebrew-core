class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.5.tar.gz"
  sha256 "361b3e069308ce1d9505d1cb927999ac448811a3425c724123e0c48602a9d1e4"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
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
