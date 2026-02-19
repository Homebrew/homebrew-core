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
  revision 1
  head "https://github.com/facebook/zstd.git", branch: "dev"

  # The upstream repository contains old, one-off tags (5.5.5, 6.6.6) that are
  # higher than current versions, so we check the "latest" release instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "628a4ef53428d0078e3d76d297171ce8d0294f5ec1de3f20305e08c4dd333565"
    sha256 cellar: :any,                 arm64_sequoia: "d72adf48460a8384b256f88061cd7b9df4977df7fa2e0794051d427db754a565"
    sha256 cellar: :any,                 arm64_sonoma:  "35b5150b27512a94ebaee7b4399aaa8adf42d247e6968319e4aeac3c05365281"
    sha256 cellar: :any,                 tahoe:         "90c345a174a631a157f7ea056fe41205fb77778e65d4bdc91097a3fb3a62faa6"
    sha256 cellar: :any,                 sequoia:       "8b2443dfa62b9d28cf0321e0e670bb096b2680fe72739999228291f36018311f"
    sha256 cellar: :any,                 sonoma:        "8b8656acd6f30bcbbb9a033ae840afea299c9f0852f71b7540492b0fe7a36742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575617c1532fe90e212c052fb14fcd4fa295890e3bc9ac69dc52404a04a95855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5ca8948526a2e3a487db0cd0acec9f4b415d5a4b08cffe27e2ea0c339c9dbe"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
