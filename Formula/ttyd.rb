class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.2.0.tar.gz"
  sha256 "00f8399a1045057a55a5a5dd2540bfbf39df972ad0c1c2a9e3bc94574514c9bd"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "9abc974daa6219a17503c18e53745c730686bfd8bcbba8d97836d635ca51dfb1" => :sierra
    sha256 "7d53d3dd0c074df356a4cd9aec9a0c7720259229d5671a22857af4ce9c7b8d04" => :el_capitan
    sha256 "bb6f94e15157cf7a07e2d8fd6656e2e23be6ae9de8b258d032590ed88dde86a9" => :yosemite
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
