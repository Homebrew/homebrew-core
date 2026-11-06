class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "e49f1e2686058b1aa1ae30e84b00248da3d109b9b8fce682058f1b53c0e2280d"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "244579c2acb67012e0ce31458b0eab069e962c0e1a92ecdbc390e357ea9c353c"
    sha256 cellar: :any, arm64_tahoe:       "5fc4dabd44395ee6138c56b70983395ba02605039b7abcfd994596ce0a1032b3"
    sha256 cellar: :any, arm64_sequoia:     "97bdf557640c8cb51188dffb81081d06df728fb9e4ccb6934d7d63da7da2c8c0"
    sha256 cellar: :any, arm64_linux:       "5d91ece6b7924ab5e7bd5fa684fc53ef906162b658fff438059bf63eab6b4659"
    sha256 cellar: :any, x86_64_linux:      "10a26e9f0dc4cc36d9b8f3dabb3e2657fd915e2f96f84d8357564a161924f3ed"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libks"
  depends_on "openssl@4"

  def install
    # cotire builds a prefix header from the `clang -H` include list, which on macOS 27 also has `SDKSettings.json`
    system "cmake", "-S", ".", "-B", ".", "-DCOTIRE_ADDITIONAL_PREFIX_HEADER_IGNORE_EXTENSIONS=inc;inl;ipp;json",
                    *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    # https://github.com/signalwire/signalwire-c/blob/master/examples/client/main.c
    (testpath/"test.c").write <<~C
      #include "signalwire-client-c/client.h"

      int main(void) {
        swclt_init(KS_LOG_LEVEL_DEBUG);
        swclt_shutdown();
        return 0;
      }
    C

    modules = ["signalwire_client#{version.major}", "libks#{Formula["libks"].version.major}"]
    flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", *modules).chomp.split
    system ENV.cc, "test.c", "-o", "test", "-I#{formula_opt_include("openssl@4")}", *flags
    system "./test"
  end
end
