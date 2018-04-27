class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.3/xrootd-4.8.3.tar.gz"
  sha256 "9cd30a343758b8f50aea4916fa7bd37de3c37c5b670fe059ae77a8b2bbabf299"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "bd52bd5c1eb23dc62f59b3181b44de2188d25a11190d8b0cd22563ac1c2c6ae8" => :high_sierra
    sha256 "dea47c161b6d717525f5ff9fcfb395c287a8379cc74ba28db0de14071a9aed3d" => :sierra
    sha256 "5cd04eb4f45d29817b534a2d037b12784c7747e8582f399b4649632078be1dc5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
