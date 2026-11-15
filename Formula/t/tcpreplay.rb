class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.6.2/tcpreplay-4.6.2.tar.gz"
  sha256 "ac4cbc58b4121edb273bc7d4603dfd6a762e7d344981233c8a253425d9dddd8f"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f3959451fd95fd2300d7c5389ffe810484fb38b9577cefa4b1c7accbbddf023"
    sha256 cellar: :any, arm64_tahoe:       "9c83ac7509ff1ffc75ebda9f16404a461b5ce52ed96543ca17e5eaaaf6384e93"
    sha256 cellar: :any, arm64_sequoia:     "2eccecfe49e18611db2e13388984529e50a94d1ad52058a81acf0118662491cb"
    sha256 cellar: :any, arm64_linux:       "e66b9c71d410a403ea26f83206b70a5f0c52725b27a5907c404dc2db7fe9c7e6"
    sha256 cellar: :any, x86_64_linux:      "1b4286a1196a6ea188b35e5d4fa8f576f6186f9dd4c471d0bf08e1bc06062acf"
  end

  depends_on "cmake" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  deny_network_access!

  def install
    args = %W[-DWITH_LIBDNET=#{formula_opt_prefix("libdnet")}]
    args << "-DWITH_LIBPCAP=#{formula_opt_prefix("libpcap")}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
