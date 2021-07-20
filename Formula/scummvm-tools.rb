class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.2.0/scummvm-tools-2.2.0.tar.xz"
  sha256 "1e72aa8f21009c1f7447c755e7f4cf499fe9b8ba3d53db681ea9295666cb48a4"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/scummvm/scummvm-tools.git"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "aee03cae297adf7d8dea7810148e34669a533cafc8bd4fc136d01d9602654afd"
    sha256 cellar: :any, catalina: "e5adfc7c4a46b93538f4eb6ae92d74d089c5dd0702709bec10a2b13e507d3b30"
    sha256 cellar: :any, mojave:   "cbd440b905907ecffa3e63ad833f73c3263f8a4970c01cc0ae83de131fa83272"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets@3.0"

  def install
    # configure will happily carry on even if it can't find wxwidgets,
    # so let's make sure the install method keeps working even when
    # the wxwidgets dependency version changes
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)?)?$/) }
                    .to_formula

    # The configure script needs a little help finding our wx-config
    wxconfig = "wx-config-#{wxwidgets.version.major_minor}"
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
