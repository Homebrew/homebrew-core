class Spoa < Formula
  desc "SIMD partial order alignment tool/library"
  homepage "https://github.com/rvaser/spoa"
  url "https://github.com/rvaser/spoa/archive/refs/tags/4.1.5.tar.gz"
  sha256 "b5d323740b01255c55725e88db2548c666a05bc83b825c19cfac10586e21e7b3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "c9fccbc0014b8c1f495ddc9073dd51f69d0a10aefc46e10b166311c1e4724d60"
    sha256 cellar: :any, arm64_sequoia: "44cbe5908a4d582d75edf115868fadb1247b1f6111ca0f2974e50a1e74b5f440"
    sha256 cellar: :any, arm64_sonoma:  "749823a0c1e16ab05d1d916d45bfb74f9abda75bee68c6d6ae65955efb76bedb"
    sha256 cellar: :any, sonoma:        "f5773e569d8b1bb47043cff37f3dcde4d11e5142a28a7ffd8b8465d77e410583"
    sha256 cellar: :any, arm64_linux:   "caf94661a23225cae4a559cdd3867f368e62b5eb44af4fc05d256284cb05d0ef"
    sha256 cellar: :any, x86_64_linux:  "1185760cad8547073d91443bbe6965ac39a88fe8d9b04e6098d6d170d36809bd"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
