class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.6.1/tcpreplay-4.6.1.tar.gz"
  sha256 "cc3642816073fb1d96b3af36df4fb66c11f523da427f95b7b0c4c99deaa53afb"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f00f0a04e138f8bca1a4bb268347077c427d0d69693ff5a703470647e4d95ac"
    sha256 cellar: :any, arm64_sequoia: "739744b925f3e95a6aa47994fa2296bd542f2e7f889c0efa4100f150504fd508"
    sha256 cellar: :any, arm64_sonoma:  "f140764c251c1a9002a46b22a66858180d4a81761e525f904ed97f828fdf56d7"
    sha256 cellar: :any, sonoma:        "cd6cee15052e9cd27382d9a26aca7d7500790a0bef37493d706c3f74844fa361"
    sha256 cellar: :any, arm64_linux:   "f0fdd136c230d393119fb7922ed4d2208efd064604e3a3ea62429119a7168d43"
    sha256 cellar: :any, x86_64_linux:  "75bc81a8180facd2272225798d996cc81fe5858754955b600b31418baf648b58"
  end

  depends_on "cmake" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

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
