class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "336c88a28015cf666bdbb070e9e11ce53dfd05baec074171fe8866945b68e8f9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1cd355ddde0c2bd04c7eee3d89eb8d7e02a37463810733ddb7b9866b8059d00a"
    sha256 cellar: :any, arm64_tahoe:       "348229694a18316b1d9ddbe739b3352eb412f39f348d434bb9fcd0af732abac2"
    sha256 cellar: :any, arm64_sequoia:     "f24eb3f4de098559a6c178bf20a7ff78be0a3efbe0e717907b6dd3976d3eebba"
    sha256 cellar: :any, arm64_linux:       "c28d772e0ee183cfa9b3ae4d3392152fc16858864b40939c605d1d527144b48c"
    sha256 cellar: :any, x86_64_linux:      "d5155d2c4d6ac3d6295284084bed1a684f039157154e7bf8527636b4051e1037"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libks"
  depends_on "openssl@3"

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
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
