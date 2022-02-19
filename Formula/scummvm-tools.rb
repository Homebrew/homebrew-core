class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.5.0/scummvm-tools-2.5.0.tar.xz"
  sha256 "5cdc8173e1ee3fb74d62834e79995be0c5b1d999f72a0a125fab611222f927da"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73ef45568a2f2c3eb2a8380d8e82d91883e65f29b68ce8075b6c6c70cecec2c1"
    sha256 cellar: :any,                 arm64_big_sur:  "183d19df8632730d2151dd50f4cea6d2a1b84aadc781b6060bcbc97a0d30987d"
    sha256 cellar: :any,                 monterey:       "2fdfe65529343f31ba2546a77cfd6dee2231154398ffbe16499b02128ec0a959"
    sha256 cellar: :any,                 big_sur:        "3ad6ba0e27b1af1efe346f322ffbe516ac3f86231c502988121f20ba1b30351e"
    sha256 cellar: :any,                 catalina:       "d8fc65646ca7e7ef48152d0b480fa7741ca8293adca7b8fe4d26f0345c848e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e336efaaf645f0ec4f87e1de4355dd6fd745d8debf64c7724936a5b361f48862"
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
