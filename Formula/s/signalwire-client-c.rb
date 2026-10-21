class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "336c88a28015cf666bdbb070e9e11ce53dfd05baec074171fe8866945b68e8f9"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4266e744a8932d7f0b6c2c49cf3b10d43c1366848302301e6c0419c58f7ff11"
    sha256 cellar: :any, arm64_tahoe:       "e09eaa096c08a57471edd369854a84abe47b512e93af7f0c5ba8a246f93e5f41"
    sha256 cellar: :any, arm64_sequoia:     "5a040ba0824bca14a78575f224fc903692ebf2f7e42872820a93040b3d4fffe7"
    sha256 cellar: :any, arm64_linux:       "dbe2c78a0fd750cb01b17dbc94dc67792e1b953ce194adaaf4f37ac52fa471a8"
    sha256 cellar: :any, x86_64_linux:      "2c36c0ef7fa083a610e56d9b8af472f814e99fe06d8875306cda0dacab02d8d1"
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
