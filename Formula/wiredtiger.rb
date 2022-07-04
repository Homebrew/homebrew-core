class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "https://source.wiredtiger.com/"
  url "https://github.com/wiredtiger/wiredtiger/archive/refs/tags/11.0.0.tar.gz"
  sha256 "1dad4afb604fa0dbebfa8024739226d6faec1ffd9f36b1ea00de86a7ac832168"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4b72a7ac0c4f99e3fa6cdd8395f03bf0c819ccbcd90e9e4ce373de6e016180f4"
    sha256 cellar: :any,                 arm64_big_sur:  "2e2b170afa925805d7f94e127dc6c66f7ae5d042a37860e736e9c6cbf1696acb"
    sha256 cellar: :any,                 monterey:       "2d693bed27b7602f8645f861bd063f98ef9e9653294e238550a57c4fbb762924"
    sha256 cellar: :any,                 big_sur:        "73dec56cf3779376bb1e111c6d96900bfd73e5df072dfce752defaf06d98b167"
    sha256 cellar: :any,                 catalina:       "16d0323167834b745163edf87b88693a7b49ace3f901042c0d78fbfbe5afa8a8"
    sha256 cellar: :any,                 mojave:         "0c2bbb142e29427648f66455b69028d1650b3d420700d31e952a70e58cc361f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e89496c6a6af975b83b16006c84ef7c69d7df3b0e127e2f58a3b2ff6cfc860f"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "snappy"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DHAVE_BUILTIN_EXTENSION_SNAPPY=1",
      "-DHAVE_BUILTIN_EXTENSION_ZLIB=1",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/wt", "create", "table:test"
    system "#{bin}/wt", "drop", "table:test"
  end
end
