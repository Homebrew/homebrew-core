class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.7.0/scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09278f6bd3012901595df46580675c75ebd70ea1030fa0ed3b141dcaf4100e5d"
    sha256 cellar: :any,                 arm64_monterey: "73e35ff4db740b50679d20761c47d1477f545b2f94cdd6bd80f83ae8c4ec7624"
    sha256 cellar: :any,                 arm64_big_sur:  "4bce202bade25138b94a1a25dabae035df1c52c62809b3145b470c018b0482d4"
    sha256 cellar: :any,                 ventura:        "7b951da64240a91e908e2134fb8bca4dc272937a617c3eeec3b6694ea1748767"
    sha256 cellar: :any,                 monterey:       "b4b8997fbd38eabe01f976c38e7c00b7cfbc862530ff50f3b0470b109ea25b33"
    sha256 cellar: :any,                 big_sur:        "e8d2f83fc35dc7e7584fb873d10d9b664a1647119dcea7a2eebca2baf88d790e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276473a2914d045c59caf62e6755d25e4359727666adab71a1d4b8dda119e64d"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets"

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
    system bin/"scummvm-tools-cli", "--list"
  end
end
