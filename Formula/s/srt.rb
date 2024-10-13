class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "befaeb16f628c46387b898df02bc6fba84868e86a6f6d8294755375b9932d777"
  license "MPL-2.0"
  head "https://github.com/Haivision/srt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f0cc017d29f0d2e3661849d96018c568daf970e0ee45e0933e2c12b81bd4df32"
    sha256 cellar: :any,                 arm64_sonoma:   "b77e98814ca5b954a11620a787f6e008950e39b7929a45d02e2362b2858e8462"
    sha256 cellar: :any,                 arm64_ventura:  "4f4d675e7fb8193e53e23b95b993dd069d8bfd22bdb743b252a1679bb2fd7efc"
    sha256 cellar: :any,                 arm64_monterey: "3add52bf295a9ec73412af7da7dd62af22068b0b8a045bedc2069f0a509fadb2"
    sha256 cellar: :any,                 arm64_big_sur:  "b2a62a80b0b5356da5e9d78e62a57c3fd11e1c1b286fea2689eb0a155b639e20"
    sha256 cellar: :any,                 sonoma:         "9339ab535392bd9c0aab1a2fbfcd1a81b1ba74c82aad7e343c397e6989c36ca1"
    sha256 cellar: :any,                 ventura:        "38af0e7432ea1a72c0dc5dbe805fcb0a994fdcc9aa3b7706ba158de466158c12"
    sha256 cellar: :any,                 monterey:       "629a69b276cacd1002765edc1737dcb191d4d9186511f53413440b729e9410ef"
    sha256 cellar: :any,                 big_sur:        "c1f0f3d541a086465aa9c27740e01adb11f2a1d41df526a9c1bddec670833ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fbdc07f36aa1416a9a7345d63b89c1db571fc1d0b4a9d6f866c39b5edf1a43c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]
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
