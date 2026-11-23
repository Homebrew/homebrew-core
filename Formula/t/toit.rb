class Toit < Formula
  desc "High-level programming language and SDK"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/toit/releases/download/v2.0.0/toit-v2.0.0-with-submodules.tar.gz"
  sha256 "9851b8230031503a737b20c75113546598ae69d89a5ea45b0a084764309a8798"
  license all_of: ["LGPL-2.1-only", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "f5456fb455b5c8cf8a7c2b0c6718cdf2e6eb0a98a437c87272f9ccc502eaf0f6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85fd14fcab0bda2ef948b2868d5b4c6a3c7b685e7fa485dc2d2b6b98ed3a048f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0588b2697be25787cba0d12a414b165d3543fc98f7d2e9ebe1825745ea3456b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92ce4a5832f1e44ce53a580cef9f6d553aaecc75ad6fd2772d3c9e2b14ab731b"
    sha256 cellar: :any,                 arm64_linux:       "fd1ffcbcb5ac09a7d6ca5938e9f2d34c197271ac54907189ab90a70a715e3797"
    sha256 cellar: :any,                 x86_64_linux:      "1f05478dfc457f6795ad357405551271b307dba08c43db1e5d79b3ee2decc210"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Toit requires its bundled Mbed TLS configuration and allocation-failure
    # patches for garbage collection and retrying TLS operations.
    # Configure directly so Homebrew controls the architecture and compiler flags.
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/toit version").strip

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    assert_equal "Hello, world!\n", shell_output("#{bin}/toit run hello.toit")
    system bin/"toit", "compile", "-o", "hello", "hello.toit"
    assert_equal "Hello, world!\n", shell_output("./hello")
  end
end
