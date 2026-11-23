class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/archive/refs/tags/v4.6.4.tar.gz"
  sha256 "e6aa11c8b948f1a9e4b682d9f083a6f4874b4269a37ef09151f76634f726e400"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]
  head "https://github.com/appneta/tcpreplay.git", branch: "master"

  bottle do
    manifest_sha256 "de44b79d89a70c7aab70042997d34924b1836e9e0fb8b8cab24702ae5b4e72ec"
    sha256 cellar: :any, arm64_golden_gate: "e3b3da2dbff74e922cbc50621b5d54dd06f6b741d91ba5f2ff475c1702a58ef9"
    sha256 cellar: :any, arm64_tahoe:       "c2628b0363bea16ac99b22f8a58439f607d49533c215c71d77b7d991418a1955"
    sha256 cellar: :any, arm64_sequoia:     "b72e6ffa300c51971f8e3947a00bbd8101b73338669cbc81c3573a505f53806c"
    sha256 cellar: :any, arm64_linux:       "54c2e898c04c6a20fe162ad98e4495d0c8093bd8dbaa25465f14ea9a037fe1de"
    sha256 cellar: :any, x86_64_linux:      "4d62ef82f4d34ac32ca4e5a36aaaed520f89dfe30c9a54de44be7d9f0a380f6a"
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
