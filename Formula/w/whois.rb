class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.5.22.tar.gz"
  sha256 "b7de4288700951b141420e2b4408f0906eaf4e97409cf5043aee80ef4d31e2b4"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "425bf061d39a4bbdb721092747487b0a64e5587d92e9a515684ec65a19443a8f"
    sha256 cellar: :any,                 arm64_ventura:  "eea750fb9406d26fae71b91de07ab7bfd676320c461832a81b3510b30328c7fe"
    sha256 cellar: :any,                 arm64_monterey: "10dc4c892f203027f9be464afabe28cf509691fca9734bfc7be13d7b09710565"
    sha256 cellar: :any,                 sonoma:         "e9a41cccbf90c3ce9f9f74a89ded77c252afa19c85a0d5c1e0dc9e636e616a7c"
    sha256 cellar: :any,                 ventura:        "e8a68e0c2c28383ac32f4b4aa1d4b51ed48a4ee034fa34a6479f25bdbb848dfd"
    sha256 cellar: :any,                 monterey:       "cdfbad4400f757ec7589bf3a7ce2a225fc339d97d014b6adac61bc12a3b6d912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dd90cf68ce9815724f8826b50f3e87e135c1e070d0db635b817506b3d4ae092"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
    end

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
