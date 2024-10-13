class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/refs/tags/v1.5.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.6.tar.gz"
  sha256 "30f35f71c1203369dc979ecde0400ffea93c27391bfd2ac5a9715d2173d92ff7"
  license all_of: [
    { any_of: ["BSD-3-Clause", "GPL-2.0-only"] },
    "BSD-2-Clause", # programs/zstdgrep, lib/libzstd.pc.in
    "MIT", # lib/dictBuilder/divsufsort.c
  ]
  head "https://github.com/facebook/zstd.git", branch: "dev"

  # The upstream repository contains old, one-off tags (5.5.5, 6.6.6) that are
  # higher than current versions, so we check the "latest" release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "487f35700f563b07036cfd429e4e7a4e37f13e22578e688cbfee2fa9484aaf9d"
    sha256 cellar: :any,                 arm64_sonoma:   "2028141683f55bffcd0693b9e49eef1e3dabc1e184214cacb173ca9bd54dabc0"
    sha256 cellar: :any,                 arm64_ventura:  "035cbadb205abbe00107f0c7746f3715e3841c007e4b3a309398e65d50c43cf5"
    sha256 cellar: :any,                 arm64_monterey: "7f12fa16033d6576099c481f93a7423a526a7b3252a0ea0921ea0016c18f49f8"
    sha256 cellar: :any,                 sequoia:        "eb32988fe6b57b6a5f46ed6de10f0e7c74177c8971f4ae1f9c6e7cd4af539a77"
    sha256 cellar: :any,                 sonoma:         "09953f22fd56bc85e0d7ceac8de7e35ed622f3affe78dd782154e5e21623037b"
    sha256 cellar: :any,                 ventura:        "78fd5d1b6afaef60879445e3de8227257e79ec6fca6af1e1324896bc93cf2a75"
    sha256 cellar: :any,                 monterey:       "b5099f7c339af2fff89af3a844a004b35aba400787ef71e1db6e856889f56557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6ddbd4c969bb84261f12b759fb78a828d6f734c9e515793c6ac2c3a846b01e"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    # Legacy support is the default after
    # https://github.com/facebook/zstd/commit/db104f6e839cbef94df4df8268b5fecb58471274
    # Set it to `ON` to be explicit about the configuration.
    system "cmake", "-S", "build/cmake", "-B", "builddir",
                    "-DZSTD_PROGRAMS_LINK_SHARED=ON", # link `zstd` to `libzstd`
                    "-DZSTD_BUILD_CONTRIB=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DZSTD_LEGACY_SUPPORT=ON",
                    "-DZSTD_ZLIB_SUPPORT=ON",
                    "-DZSTD_LZMA_SUPPORT=ON",
                    "-DZSTD_LZ4_SUPPORT=ON",
                    "-DCMAKE_CXX_STANDARD=11",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"

    # Prevent dependents from relying on fragile Cellar paths.
    # https://github.com/ocaml/ocaml/issues/12431
    inreplace lib/"pkgconfig/libzstd.pc", prefix, opt_prefix
  end

  test do
    [bin/"zstd", bin/"pzstd", "xz", "lz4", "gzip"].each do |prog|
      data = "Hello, #{prog}"
      assert_equal data, pipe_output("#{bin}/zstd -d", pipe_output(prog, data))
      if prog.to_s.end_with?("zstd")
        # `pzstd` can only decompress zstd-compressed data.
        assert_equal data, pipe_output("#{bin}/pzstd -d", pipe_output(prog, data))
      else
        assert_equal data, pipe_output("#{prog} -d", pipe_output("#{bin}/zstd --format=#{prog}", data))
      end
    end
  end
end
