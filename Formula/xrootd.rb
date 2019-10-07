class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.10.1/xrootd-4.10.1.tar.gz"
  sha256 "ad14174796328e0b62f13505862c8cd1b12842ec4b5f807b0efb3bfaac7a760d"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "edd44628a8fd73d38adeb7edca07b0cd01578c0f6625f1382e8be06e2834c911" => :mojave
    sha256 "3d2ce7a46a35974c054427d40ef1c7e9e1f94c6542779eb07194b83f6a5538bf" => :high_sierra
    sha256 "129c1378af87049ffaa76b50569688cf3aaa00b21ffc018685eff9bfd11d3a55" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

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
