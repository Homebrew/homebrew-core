class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://github.com/stoken-dev/stoken"
  url "https://github.com/stoken-dev/stoken/archive/refs/tags/v0.93.tar.gz"
  sha256 "102e2d112b275efcdc20ef438670e4f24f08870b9072a81fda316efcc38aef9c"
  license "LGPL-2.1-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "120ccd4eea9a910df80ea95e8041919027ef03d74fa87f982e25da2dea11bd72"
    sha256 cellar: :any,                 arm64_sequoia: "1506760360fda777047ae3f92e7fabd9b912d89a1684d55bd523850438b77bda"
    sha256 cellar: :any,                 arm64_sonoma:  "6b0705d78068002077390e931ffe342184ef0f63a0fe8dbbd9fbe3a1e7b6b145"
    sha256 cellar: :any,                 sonoma:        "1655d0e1253f345ab475d8038d627266a714d2a055a9d0f84d636ed9f867cefc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48fb52e148c6e57cc6ff3423f04f7ced5302bf5c64c3eee2144272e2675288bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99879a1ca2556a68d5c70e0e48d1ba6fcb05dae8eeed6b5899b09a3fc192595c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "nettle"

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"stoken", "show", "--random"
  end
end
