class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v3.0.0.tar.gz"
  sha256 "e3151cdcdf695ab7581e01a7c6ee78678717d6a62ef09849b34db39682535454"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "684a70d7b7de73b6e8f8784d371bc09f378853a8c29f87bf30ec3e3e1846e966"
    sha256 arm64_monterey: "96bd279a71f9d5e798047080f563868ca79b18a98db11edc138e20cf6eacf837"
    sha256 arm64_big_sur:  "058c06f623a87893e4df2df875d34542935002167a7f17247a3dd6bb5d69fc24"
    sha256 ventura:        "5a4d3cf68235de582a225e82e78b5672af74ae1fd1ef843093232015e5c1f751"
    sha256 monterey:       "ed089861c3c552d6531cef3f75067dedb46b74ddff4d43bfb37b3dc20c4eb4b0"
    sha256 big_sur:        "259f7d1b308ae26692995457b9933fd9bb4affcf17dd4429effb503a0f1b1d73"
    sha256 x86_64_linux:   "ef0ab2fc170be2e64fc1b32b55b45b7e498d827f97c258483b399e698ecd6d61"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "libdnet"
  depends_on "libunistring" # for unistr.h

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  def install
    inreplace ["conf/zmap.conf", "src/constants.h", "src/zopt.ggo.in"], "/etc", etc
    args = %w[-DENABLE_DEVELOPMENT=OFF -DRESPECT_INSTALL_PREFIX_CONFIG=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{sbin}/zmap", "--version"
  end
end
