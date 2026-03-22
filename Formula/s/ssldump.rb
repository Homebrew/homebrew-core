class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://adulau.github.io/ssldump/"
  url "https://github.com/adulau/ssldump/archive/refs/tags/v1.9.tar.gz"
  sha256 "c81ce58d79b6e6edb8d89822a85471ef51cfa7d63ad812df6f470b5d14ff6e48"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d482537a888c36ff5f8a17debd299219daf35f1495717fb343b78b76ff8cabd6"
    sha256 cellar: :any,                 arm64_sequoia: "4108e474738b3c274d3124a2325e910109556d45568f6f3e299882d9a7b3697c"
    sha256 cellar: :any,                 arm64_sonoma:  "bef8ddb0f055225bd2f77fc6ad5270c52b7db46f9797a3d5e23b9c9872bd0791"
    sha256 cellar: :any,                 arm64_ventura: "b0c5a32df2ef8e072f50f5302ef2b1813de8d0b4fcd13660847b193ba1449260"
    sha256 cellar: :any,                 sonoma:        "d0e771ebfc5cac4998d58d7b84a188fb94e26ccdae77ecb8625fc0a9b5bfdf09"
    sha256 cellar: :any,                 ventura:       "9b11e1e942fddc5ff4d2189a69e9acc4bef77fa5ea0a7e6bce789804f9512c6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c413c7e9e7272a34bc3086c37c98b1ac30b291486cdf025cf0b5ed288d9c749e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a258e929e9b40617be052eb2026e693d39ec47ad006c231e2e542668ffe322d"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"ssldump", "-v"
  end
end
