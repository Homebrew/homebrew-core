class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec.git",
      tag:      "v5.0",
      revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"
  license all_of: ["MIT", "Zlib"]
  revision 1
  head "https://github.com/avast/retdec.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "636b6b44b73121f25224e327ca950576cb95a2a5fd29890c882b7336993af7cc"
    sha256 cellar: :any,                 arm64_sequoia: "2b66bd7a2b82e7c2984bf1cf7d527b8e689fa0915c5dae716500014a689d1c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "f51d9599b4ba56340e4db15fad2a5deedf84e9cb73efdc66ef8ccb35bd3fc7fd"
    sha256 cellar: :any,                 sonoma:        "600a0786558e55c549ee2f437a05adb2370866ddf23212af0d018b57d22f923d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3181456a91b4f47359036729f37ef32762af922cafd4f26451cf4f8e5eabd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6400aaaa25aba6846a2d8efd43e7c20b608a181c0cb4a2bfddb5c99618b1ac93"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"

  on_sequoia do
    depends_on xcode: ["16.4", :build]
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for CMake 4 compatibility with multiple vendored deps
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Running phase: cleanup",
    shell_output("#{bin}/retdec-decompiler -o #{testpath}/a.c #{test_fixtures("mach/a.out")} 2>/dev/null")
  end
end
