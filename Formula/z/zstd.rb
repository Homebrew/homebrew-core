class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://meta.github.io/zstd/"
  url "https://github.com/meta/zstd/archive/refs/tags/v1.6.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.6.0.tar.gz"
  sha256 "289bb207935e5b4f241239f9832e665fa6b9636c3f87f479e125371e13842b8e"
  license all_of: [
    { any_of: ["BSD-3-Clause", "GPL-2.0-only"] },
    "BSD-2-Clause", # programs/zstdgrep, lib/libzstd.pc.in
    "MIT", # lib/dictBuilder/divsufsort.c
  ]
  compatibility_version 1
  head "https://github.com/meta/zstd.git", branch: "dev"

  # The upstream repository contains old, one-off tags (5.5.5, 6.6.6) that are
  # higher than current versions, so we check the "latest" release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "906c8306968cf73983cabf73b3f19d4da11cfd556abadee81392130a882c3eb8"
    sha256 cellar: :any, arm64_golden_gate: "78df508100eba34ed911f4e3ced121d5d001f1a340ae800f38f2325df56bfe2a"
    sha256 cellar: :any, arm64_tahoe:       "406c93bb4ed7d09e857ba4d00e30fb72c2f6e7d610bd5e888a498b9269c957c4"
    sha256 cellar: :any, arm64_sequoia:     "7c49194de54641895c5c965446472552d4619e30170eb8fd9d10eef223919730"
    sha256 cellar: :any, arm64_linux:       "0b6bc6c6f35848f5205ef7619a6f415bd149af2d5ab9e82317f12bd178c20406"
    sha256 cellar: :any, x86_64_linux:      "f9fb6295ab9b8cbaef315f84ed29b42b86e4d54848d67153b2373b9d9a5dab47"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    ENV.O3

    # Legacy support is the default after
    # https://github.com/meta/zstd/commit/db104f6e839cbef94df4df8268b5fecb58471274
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
