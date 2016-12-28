class Servus < Formula
  desc "Library and Utilities for zeroconf networking"
  homepage "https://github.com/HBPVIS/Servus"
  url "https://github.com/HBPVIS/Servus/archive/1.5.0.tar.gz"
  sha256 "42fb9c060f17f040ad3c7563f5e87c89f5a221a5aa7da21384fc26b9c725ecc8"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Install tests to share/Servus/tests so that we can test later
    mkdir share/"Servus/tests"
    (share/"Servus/tests").install Dir["tests/{serializable,servus,uint128_t,uri}"]
  end

  test do
    system share/"Servus/tests/serializable"
    system share/"Servus/tests/servus"
    system share/"Servus/tests/uint128_t"
    system share/"Servus/tests/uri"
  end
end
