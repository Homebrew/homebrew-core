class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "d219c7f130c6f1565f769b0e079d9509a6aadfe6690423b4428d027fdd43ecd1"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b9980ce74dccd2db75e71fc993fca8e7349ad9ac53afe5526733a3a95a54a5c"
    sha256 cellar: :any,                 arm64_sonoma:  "5b241adffad818826ee2d8a03c95e9cf7f818436e142fa8444d3fcb485bd57e5"
    sha256 cellar: :any,                 arm64_ventura: "3ae63df848ede6c098bf46af84018c502efb960a356f28ce67de290ebb94908c"
    sha256 cellar: :any,                 sonoma:        "ae44dc18f2b8a408b8b9aad625c1a95ee4df3353bed0101ba7aaf0039d783905"
    sha256 cellar: :any,                 ventura:       "32db1168ea21c3c94774318be6dca256f8a3a207f5dde742803b20427cecae0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d3dd5f7356299c04c87745672edc38f70cfdb16fbf4bc38bbdc8118f5275db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b16b682d44bee04915e4fd039b7ac36361dd7dcf17c990beca96ec588f809c3"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
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
    system bin/"whois", "brew.sh"
  end
end
