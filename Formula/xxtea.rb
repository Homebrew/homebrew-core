class Xxtea < Formula
  desc "Extremely fast encryption algorithm library for C"
  homepage "https://github.com/xxtea/xxtea-c"
  url "https://github.com/xxtea/xxtea-c/archive/v1.0.tar.gz"
  sha256 "bf02e600649c2589d321f7e88027bb873226f718ff5580a442232717f6a3f4bc"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
  end
end
