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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ef06a37f5245d46d0aeceda9c2ebcd7032d5e1ecec16445b2df22c5eafef02c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85d80942588eadd641e9367365e9b3d46d3cebeb437d46fec5f978747579891c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "98ce4c2cef7503c98ad1388bfdf3051a719d4cedf6c51917808472027707a88b"
    sha256 cellar: :any,                 arm64_linux:       "67cef17443bb26dc5c5705455ef14b61d1b240412b2d4ce10cf547d5f3d29292"
    sha256 cellar: :any,                 x86_64_linux:      "68adaa207ca85b8762da0ff09793e4a53c5b7c8fc25cb6e65d69c1470ee8e83b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  deny_network_access!

  def install
    # Toit requires its bundled Mbed TLS configuration and allocation-failure
    # patches for garbage collection and retrying TLS operations.
    # Configure directly so Homebrew controls the architecture and compiler flags.
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args,
                    "-DBUILD_TESTING=OFF"
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
