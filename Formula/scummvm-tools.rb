class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.2.0/scummvm-tools-2.2.0.tar.xz"
  sha256 "1e72aa8f21009c1f7447c755e7f4cf499fe9b8ba3d53db681ea9295666cb48a4"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "08b599a5a43c08ac6bf0b1d9e1595eb20e930f9c5f25bc916b94529f0fab3941"
    sha256 cellar: :any,                 catalina:     "996875778890186143218b023d6bd1cb53c518d9e98e6f7409fb19b50c745be4"
    sha256 cellar: :any,                 mojave:       "221fd9eaf4604bb37fc3c204008232d7feed8b93af246772f5c436902bec8ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "04ebe28d8b59d672db9d6b3f1d0168db7d496a057726944095eb99dfd6e39aab"
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
