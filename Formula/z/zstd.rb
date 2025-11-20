class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/refs/tags/v1.5.7.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.7.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.7.tar.gz"
  sha256 "37d7284556b20954e56e1ca85b80226768902e2edabd3b649e9e72c0c9012ee3"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ddb0c145060bc2366ce5d58d95aa205bb15cb4c66948f20bb85e23fdb5eba7e9"
    sha256 cellar: :any,                 arm64_sequoia: "55a4e0a4a92f5cf4885295214914de4aefad2389884085185e9ce87b4edae946"
    sha256 cellar: :any,                 arm64_sonoma:  "60c34a6a3cadf1fc35026cde7598fbe7b59bd2e5996c4baf49640094b4ffeb37"
    sha256 cellar: :any,                 arm64_ventura: "2332527b27c6661bf501980bd71a5b4fe1b417122bf8b37d9f082e47b377b7f9"
    sha256 cellar: :any,                 tahoe:         "873feb2d747bb21708c0229bb977364d0794e65bccbf18e33934a424342e83a1"
    sha256 cellar: :any,                 sequoia:       "342e64c01287a716615d14d4a71770fc5930871dc0a965fbdda6062f80dc1952"
    sha256 cellar: :any,                 sonoma:        "77457805185cd2c70fe81245b9e2d1a3e178a1be55e032eb504391dbd4d4e9ab"
    sha256 cellar: :any,                 ventura:       "c7b411aee72bc1e36d9a2647059433da62a0ca9a4cc7baeb44a2226e0a0de8b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2148094d7e41ccbe0ac29f351d6544093d45ff0aa41f0ff90f3e3b0c594d824a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd3f9ef36c6f9b324a36c33727962c37be5d12fdbe330e9b863112f24c49e11"
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
                    "-DBUILD_SHARED_LIBS=ON", # set CMake libzstd target to shared
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
