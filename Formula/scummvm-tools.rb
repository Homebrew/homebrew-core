class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.2.0/scummvm-tools-2.2.0.tar.xz"
  sha256 "1e72aa8f21009c1f7447c755e7f4cf499fe9b8ba3d53db681ea9295666cb48a4"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/scummvm/scummvm-tools.git"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "bcc9ac03c2702194f66f8671a11d381dd4d297e6863aba2562d390ebcfee117a"
    sha256 cellar: :any, catalina: "e2a31dc63a2ed04029a80d03fe3a273b82a4bcd7e4231a339c92067f09c018f9"
    sha256 cellar: :any, mojave:   "c65273ff136c4f13931a5e1c30918e5410c8419b09dc3fd9e53057489b21ede1"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac@3.0"

  def install
    # configure will happily carry on even if it can't find wxmac,
    # so let's make sure the install method keeps working even when
    # the wxmac dependency version changes
    wxmac = deps.find { |dep| dep.name.match?(/^wxmac(@\d+(\.\d+)?)?$/) }
                .to_formula

    # The configure script needs a little help finding our wx-config
    wxconfig = "wx-config-#{wxmac.version.major_minor}"
    inreplace "configure", /^_wxconfig=wx-config$/, "_wxconfig=#{wxconfig}"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--enable-verbose-build"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
