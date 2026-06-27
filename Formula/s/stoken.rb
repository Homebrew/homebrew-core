class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://github.com/stoken-dev/stoken"
  url "https://github.com/stoken-dev/stoken/archive/refs/tags/v0.93.tar.gz"
  sha256 "102e2d112b275efcdc20ef438670e4f24f08870b9072a81fda316efcc38aef9c"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13f7f789acd86bfb43e32a93a22c14e281f0182333228f649c1fdc18bbd3d53a"
    sha256 cellar: :any,                 arm64_sequoia: "6dd71ade20837819b4d7278cff667d12707a25506af24d3c0fd63f146f21be52"
    sha256 cellar: :any,                 arm64_sonoma:  "964feda555eeeb9f2546af0830baa11d8a2340c56ecdb6c13d078b7b0c18ff5d"
    sha256 cellar: :any,                 sonoma:        "e42c126e6b6c3e2f721d1d0dad2066a07b60f5e9e9ddee3ef57576ad4c9499e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a61f32a5b5a333616b1a350b6ecf3f6f4359fff2628d56f6f5326367ca7ec9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38224776fd91dcdef6e5e4b0330583ed6b3800f1f6cc1b8a3153832e4afe3ffb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libtomcrypt"

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
