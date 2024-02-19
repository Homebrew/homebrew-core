class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.7.0/scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "342affad8075a0aefefa19c772f3ba0efc299b56f3eb30c8ace586994533219a"
    sha256 cellar: :any,                 arm64_ventura:  "2b67586af4d4a3cec81644cb17244bbe0c379bb6e77ad6bf157cdc32572cb536"
    sha256 cellar: :any,                 arm64_monterey: "d9ccc5e2ddadea3ad088371506bb04642e480491fd90a48a760e0491cd9af6bf"
    sha256 cellar: :any,                 sonoma:         "be1293f1988b909d8df79690875265df47fcb88a0eaaf1f302695563b1c29fa4"
    sha256 cellar: :any,                 ventura:        "703755bdc07dc18575bd3a6ab60e47dd65e7e683c50f2f7766099143aad75353"
    sha256 cellar: :any,                 monterey:       "0b0e577a7c015b429108786c1265e297519e238629b9a755ca44006c7ea237cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd108dbabf9c84fef7003307af68906fc7fe2e1554860644b95b23ae1e2694a"
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
