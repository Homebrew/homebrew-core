class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.12.0/xrootd-4.12.0.tar.gz"
  sha256 "69ef4732256d9a88127de4bfdf96bbf73348e0c70ce1d756264871a0ffadd2fc"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "ca8ad23240dae85b67da21790451ae0c48a6e56e446aea537eb78253cf608181" => :catalina
    sha256 "7f39d25830dd021e4bf747c851f06ec7eb8d80c10d6aa859b8a1a390993d72ef" => :mojave
    sha256 "533a3137dece016eedf34125a830937004a3bc2a907bc32929adacd5ce74f759" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
