class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "8b06862b0535d8ff4e3f0ca7cf34cebcf24972744dc251080131e517b067e60e"
  license "MIT"
  compatibility_version 1

  bottle do
    manifest_sha256 "37573e070198eafce5f6c126f77255c910e37997806b8813410e5ff1d4e90947"
    sha256 cellar: :any, arm64_golden_gate: "8c31330ccb9cd50213220968b94849caa6da9d6a4d15b8a4e87eff08f625b89b"
    sha256 cellar: :any, arm64_tahoe:       "38dcc2fed510be5a934c16acf00f2ec7b693ae1dcad2a070980956ed421676ae"
    sha256 cellar: :any, arm64_sequoia:     "0fb0887338fc85b4e3e0527628bcbac9411310513b6c0a911bfc75d2eef2b09c"
    sha256 cellar: :any, arm64_linux:       "f4f4889674bc81afda958ffa126a869c38019952ba8297db98614fdd1136a9cd"
    sha256 cellar: :any, x86_64_linux:      "c76a7e6322bfee339309835b2e3168245f64e3359f45f9a71be247d6da41f1fd"
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

    libks_major = Formula["libks"].version.major
    modules = ["signalwire_client#{version.major}", "libks#{libks_major}"]
    flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", *modules).chomp.split
    openssl_include = dep("openssl").opt_include
    system ENV.cc, "test.c", "-o", "test", "-I#{openssl_include}", *flags
    system "./test"
  end
end
