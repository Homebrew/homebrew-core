class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.2.11.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz"
  sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

  bottle do
    cellar :any
    sha256 "245a43a59c57f83848e7382974bb80a46eac1d53bcaefb1bdebd1f85107d4169" => :mojave
    sha256 "30548658b43cf66979f2756680fbb32d3c19c967e478ceea22d07f536b22bbce" => :high_sierra
    sha256 "f822b4dbab4a15b889316b89248c7b4d15d6af9dc460bf209b9425b0accb7fa3" => :sierra
    sha256 "3f912f6f1ce6c586128ebde29756c883b89409e652ca7aa9a29a773c2d4d0915" => :el_capitan
    sha256 "5b969eb38b90a3e31869586df9d62e59d359212b16c6a270aee690dd67caa491" => :yosemite
  end

  keg_only :provided_by_macos

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert_predicate testpath/"foo.txt.z", :exist?
  end
end
