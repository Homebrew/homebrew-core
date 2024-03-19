class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-1.13.1.tar.gz"
  sha256 "c8da2b10f1bfec2cd7dbfcd33f4a2338db0765d851a50583d410bacf055cfd0b"
  license "LGPL-2.1"
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b79928275529b55ab078a708cbfb98e174f7e5b7d668bf86bccb0634f443f0f"
    sha256 cellar: :any,                 arm64_ventura:  "c921c460750f74d8c025ed12189704bba122e1883c1e034b2cc86d451e81dfbe"
    sha256 cellar: :any,                 arm64_monterey: "5d012c93d5f25fded733a3b8cb3d834ab25ff121e32265d5bfcf38634b1171e5"
    sha256 cellar: :any,                 arm64_big_sur:  "f1b3bc322c1588095ffaa5bb957af0e3b53651d022e3b3ec0616c58cb4c6e6cd"
    sha256 cellar: :any,                 sonoma:         "87427348eee256dd9d02bcfe85d909fedba634ce9325a7c0800a4a40a202b28d"
    sha256 cellar: :any,                 ventura:        "a0e1acf193f45734d34409416134a0181ef2a70a23db77564b2f6d1e3dfb2f9b"
    sha256 cellar: :any,                 monterey:       "585afe1f5b71dd705e40075c5fdc898d5aa137a278a64c141ee5e249dcb5a27b"
    sha256 cellar: :any,                 big_sur:        "ce0540a13cf0cd98e968f40c46e154a3947a0c2d682f5023cd14830ae9b1f0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1762030a268fcab40eb571d7ac9a6065db25f7b6c1898ce142f49d5f3f7bf80e"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
