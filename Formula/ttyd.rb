class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.2.2.tar.gz"
  sha256 "6e85335c11df68e6401178269920a586bce7e66045bd0b225f6d2bc58356d105"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "549b8552e837210e4482058acd5748753d5a738069f449d929019cfa56fed2f2" => :sierra
    sha256 "c5fbad8edbf3b04f748dbc3315e2ff9cf1b5f3d66f2a236527fa87ef33c55a94" => :el_capitan
    sha256 "8da55f39a2c875c339da444cf90303505ddc5c27d4a2f63ccf48cb6610d19f36" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
