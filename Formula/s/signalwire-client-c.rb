class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "336c88a28015cf666bdbb070e9e11ce53dfd05baec074171fe8866945b68e8f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fa3e639978d147b3bdde2bd26a5d6cc166ba1079d3bb01abf9cd00040d63dd9"
    sha256 cellar: :any,                 arm64_sequoia: "b51d2b663c7d248f5a65c6eff63d43f49b20c2401946e426a29a6114ed12ee67"
    sha256 cellar: :any,                 arm64_sonoma:  "1c1654fd69c722d7a6e23f47ee6e8bf1884447f66d9f1731afe28f94fdebd2da"
    sha256 cellar: :any,                 sonoma:        "858aaffb29a67fcf11f2e0f11635c309ef0d3ccb834d4c876caca5f1445fce3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f627c192ac1ca0d74004678e131290de2e1d6725f39656d96f0c38572b082a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3d5525d1058fc641f1f5a254ecb949798e098a5bbf7e470e70db5f7c17c80a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libks"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
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
