class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://github.com/stoken-dev/stoken"
  url "https://github.com/stoken-dev/stoken/archive/refs/tags/v0.93.tar.gz"
  sha256 "102e2d112b275efcdc20ef438670e4f24f08870b9072a81fda316efcc38aef9c"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "07719ef72ddd93085d5cea66cf89371b128668f37532f9996d595f7280f46ef7"
    sha256 cellar: :any,                 arm64_sonoma:   "ef8f9c9c4a3edbf707c41392dc366204f0a65ed60420b192108cf20f5a84c18e"
    sha256 cellar: :any,                 arm64_ventura:  "d8f2d8b3a88c1361a7f82da8aeccc3272f568d9ec9fb031dd547f76bc865d76e"
    sha256 cellar: :any,                 arm64_monterey: "bd715ff4141234ceacd14910254d1b372b98fca4e490286017055b9345a66b69"
    sha256 cellar: :any,                 arm64_big_sur:  "b14841f8656142a47ad851e2e524642dd71c4ee7c568abfbbe626bf2570d4336"
    sha256 cellar: :any,                 sonoma:         "8b6a3bb0bc8d471162e70570a9effdc056f007d43eeb6974b452518fe6c4162f"
    sha256 cellar: :any,                 ventura:        "205dca5a696dfd3a9e7ccd43300325209397b32793ea336d2d80b8d93a45369b"
    sha256 cellar: :any,                 monterey:       "14c75a261aa3357a8bbc8da63403727e3dc975df604973235d35da28f58c25da"
    sha256 cellar: :any,                 big_sur:        "59e08afd001c42067ef8502638958742426da6bbdae56ac5b731a5aa4bcbbe51"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0db93a098ac78ca584ee522259e255cdbf0d9e2d567aee98173a7e546c53e18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc692874b7298e95206d14dfbafa4fe4344f1b1fa07ad394ec318215f09220a"
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
