class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://systemc.org/overview/systemc/"
  url "https://github.com/accellera-official/systemc/archive/refs/tags/3.0.2.tar.gz"
  sha256 "9b3693ed286aab958b9e5d79bb0ad3bc523bbc46931100553275352038f4a0c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15b664b77b7660ce613e8219fb38b3dc192431896fe645906b97a57ce3ef03d2"
    sha256 cellar: :any,                 arm64_sequoia: "be8e6a1922de610fda5745e21b8a2f1a8ae64db9afef613395ada807f218caf9"
    sha256 cellar: :any,                 arm64_sonoma:  "e4c83297291edc511fcef51f9a87d919b4a7bb05059cf90be30de4614dd4f360"
    sha256 cellar: :any,                 sonoma:        "6e344cab620163cae309e39ddfef2a322d4906340b75b73a5ce236939f5dbfa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fa78339db2c12469cd5b4af5b79be4c5b0ec1c75cee2d28a54a049f62ad4ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b646135f7f9d2940ab5b0c4c6eafc5fcf0c2632933664964d5747cf9e1c87ac"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-unix-layout", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    CPP
    system ENV.cxx, "-std=gnu++17", "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
