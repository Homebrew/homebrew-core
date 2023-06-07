class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.5.1.tar.gz"
  sha256 "af891e7a7ffab61aa76b296982038b3159da690f69ade7c119f445d924b3cf53"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8f0a85c0e017f661d07dda9b6a039e67ae213fdb73837cc0d075d1f83ff10a7"
    sha256 cellar: :any,                 arm64_monterey: "53f96b0133e3829e7ed06a5221facff13b9a0b6f0aa785e96e5a124dec83802e"
    sha256 cellar: :any,                 arm64_big_sur:  "2cf874a22d85df40da98de8fb6ce690511ff68071043784d6088ade342b9d9cf"
    sha256 cellar: :any,                 ventura:        "0ac312b97e03d8c6e6df9715e8a798db08767b2491b65a8c689573ffb5d58494"
    sha256 cellar: :any,                 monterey:       "9cb143f5b2a095225e6d7901f9cd65636024c0800fc6fb42c5d3879d6fb2459d"
    sha256 cellar: :any,                 big_sur:        "1ed0443edb116e2592a431640dbace7c1db78dab82abbc3a90a8a5a20f2b89d8"
    sha256 cellar: :any,                 catalina:       "c53d6c05a25606cda6d7f9ca670a84c7e4700fa072b20e70ddcf375a97761d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88bce985d54b923213427ced84cf5e2b6f6d87eb243505107b101b19f93e3b0d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    openssl = Formula["openssl@1.1"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         "-DCMAKE_INSTALL_BINDIR=bin",
                         "-DCMAKE_INSTALL_LIBDIR=lib",
                         "-DCMAKE_INSTALL_INCLUDEDIR=include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/srt-live-transmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
