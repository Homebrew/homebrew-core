class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/archive/refs/tags/v4.6.4.tar.gz"
  sha256 "e6aa11c8b948f1a9e4b682d9f083a6f4874b4269a37ef09151f76634f726e400"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]
  head "https://github.com/appneta/tcpreplay.git", branch: "master"

  bottle do
    manifest_sha256 "a9248bc97072b992bda013a01a80e2e7f9f48612330d7fbb270d3fb34d903c65"
    sha256 cellar: :any, arm64_golden_gate: "d68b86d3a9f771d56f5f0847b98e5fafaab8b58c367a509669f4a21cd21e0e02"
    sha256 cellar: :any, arm64_tahoe:       "30ba80f193cee6975b86543881e5f2317c23652cb4a10f196aab617486155879"
    sha256 cellar: :any, arm64_sequoia:     "1084d00a22b91bb31ac02c06ab7f9ef6fb1cc626d97b4c985e083d6c7d045fb0"
    sha256 cellar: :any, arm64_linux:       "ef1b1756039cba40d1b64e4423cdaee4678defe015d06673ab87167736f28d27"
    sha256 cellar: :any, x86_64_linux:      "98973ecaf2b0b9511b74b32b980b5e47292235bca02f18ddc58a9206038249b3"
  end

  depends_on "cmake" => :build
  depends_on "libdnet"

  uses_from_macos "python" => :build
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
