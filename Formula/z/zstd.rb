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
    sha256 cellar: :any,                 arm64_sequoia: "b039c851ef22617804576274872c33727ebb3a0b5e0db2ab62e0d8a97ec9605a"
    sha256 cellar: :any,                 arm64_sonoma:  "af7a39452f08144cb27f8f9c31feafd46beca7eb4dd3047c49925800e00c6e7a"
    sha256 cellar: :any,                 arm64_ventura: "56faac95df2a57e866c23339db384c5b3fe7d58984314c1a0bba2823123e0972"
    sha256 cellar: :any,                 sequoia:       "bcfccd14315dedf3291f77682702f80711fb8829bd14a53431d60204eb99ec32"
    sha256 cellar: :any,                 sonoma:        "fa320bd56f0b839438336ae22fa6f404522e53f8297d72de04355f5483324499"
    sha256 cellar: :any,                 ventura:       "a109e4645ddd9a1f091f082b525b5ef5032d3568c016c3ec657f63068c068cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37f70b21f32017d893b751f9d3d1f7b10e7b742b35a1d7c7c1d357a35e14cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4748929efb3666f0fd60451479cb306991c75fc6a84253e81828354185f4a23b"
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
