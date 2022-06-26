class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212a.tar.gz"
  sha256 "d986b429655dce36629d1821ea6f32d65cc418f7d22b1ea4330621bffb35c18c"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "32c28e7e8bb6c2e4c9b9b9c8f8d7093fa247c13f07059a33a5ff450fcd694c6c"
    sha256 cellar: :any,                 arm64_big_sur:  "e378f92c02320c68abb66805d10ecf7b88759027d9e24d8d6c2a9e992ff9ae40"
    sha256 cellar: :any,                 monterey:       "2bf7ff29e584306c98894e00d15aacdc1336fa6e733c78361b6578a37f1a6660"
    sha256 cellar: :any,                 big_sur:        "be6722020b6c359406e1620d82f13e11f41498e732730dadae5f350f4fdda5ab"
    sha256 cellar: :any,                 catalina:       "3b3e6cdfc534058ef687ba289cd7361c295de65e027de92dff6613df0a24556a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d5fbafb8d6a6603f7245842a4cdba8969536f764588ac6a8a092087ebf2b533"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
