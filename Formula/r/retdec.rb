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
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "2ad4e38c27ebda7ec954319fc7fdea9c53895e7afb4e01d3a252eeceb2d44506"
    sha256 cellar: :any,                 arm64_sequoia: "8ed646df7127fad1de5ffe3587ea50a102c19b5a061fe27520c0a229d60c5a37"
    sha256 cellar: :any,                 arm64_sonoma:  "dc347f9280c7321e959efb1bfbf731f515184d462fffcbf1f15e91933371e29a"
    sha256 cellar: :any,                 sonoma:        "8f3003762a514b9378f1fc3ee2653c34e73fe5748bf8e1ea3d08ca208a084b66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d02d73b84091a9f137258db276ce65059fa16e41e9f119799e6398d5c53457e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b98c2b9804c2aee53bc1396747e28241bf708f479bff58d488dd64c3775c7e1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"

  uses_from_macos "zlib"

  on_sequoia do
    depends_on xcode: ["16.4", :build]
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
