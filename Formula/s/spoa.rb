class Spoa < Formula
  desc "SIMD partial order alignment tool/library"
  homepage "https://github.com/rvaser/spoa"
  url "https://github.com/rvaser/spoa/archive/refs/tags/4.1.5.tar.gz"
  sha256 "b5d323740b01255c55725e88db2548c666a05bc83b825c19cfac10586e21e7b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad55584bc1d671174019fc33fba25846d45695b1495a8a58e4f569df3f51e4a7"
    sha256 cellar: :any,                 arm64_sequoia: "e78b56f6b7ccd0c550496370806409371af5aa0e247b19fb6a19766dc8588b98"
    sha256 cellar: :any,                 arm64_sonoma:  "a233dfaffda20031385fff9037eed19790d91745b7a158c251924de0710eac83"
    sha256 cellar: :any,                 sonoma:        "6e5926cd309fa1eeac6595bc1bedad2d27a1b9073c263829509cd9a598b286b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13f431aa4da78f6726cf32c9d188b5bde27f7120d54db94763cb5f1f7aef29fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45598cf9672ff7d9daa64cdb07d315980580e21fddb16100b4de4c8c2b849c9"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -Dspoa_build_tests=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spoa --version")

    output = shell_output("#{bin}/spoa #{pkgshare}/data/sample.fastq.gz")
    assert_match ">Consensus", output
  end
end
