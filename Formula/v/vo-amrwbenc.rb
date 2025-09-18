class VoAmrwbenc < Formula
  desc "Library for the VisualOn Adaptive Multi Rate Wideband (AMR-WB) audio encoder"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz"
  sha256 "5652b391e0f0e296417b841b02987d3fd33e6c0af342c69542cbb016a71d9d4e"
  license "Apache-2.0"

  livecheck do
    url "https://sourceforge.net/projects/opencore-amr/rss?path=/vo-amrwbenc"
    regex(%r{url=.*?/vo-amrwbenc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "654ba6332b443125e46a211f00ed4f16b219d6de0068d8a4ea863200e97694cc"
    sha256 cellar: :any,                 arm64_sequoia: "fec91381e714f851e4215e99f160daeeb8844fe28ac28bb86f4de6076eb7db1e"
    sha256 cellar: :any,                 arm64_sonoma:  "2b42ddf93167c6e68a0ff075380b69d1b03b9ead3125cf392571578c282ca677"
    sha256 cellar: :any,                 arm64_ventura: "d627a6b0fb346506f9723a73eeb0f3e3d6d267e2e657ef4f13da37131fa88a31"
    sha256 cellar: :any,                 sonoma:        "e32dbde8f52e3a617f4ee48deb707b07f530ba72206c25df1fb82b19ccf085a7"
    sha256 cellar: :any,                 ventura:       "d12ffd9e43f25d2f17e86773ac2704a37577310042799eac2b59193184e4937a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dc5fe1a71f25d535c42c04b8927b2d34eb807301f2c226f2d803b9800c96db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b6d44ce234aa2ec2c3a3a0051f0ea76b469d6bf0b285b1878f761e0c7bf33c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <vo-amrwbenc/enc_if.h>
      int main() {
        void *handle;
        handle = E_IF_init();
        E_IF_exit(handle);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lvo-amrwbenc", "-o", "test"
    system "./test"
  end
end
