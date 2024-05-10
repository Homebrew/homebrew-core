class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.7.0/scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d4497e33f5522d2b6d07b04719494a7989029463a0cd2702c29cad668ba32c1"
    sha256 cellar: :any,                 arm64_ventura:  "87869fd1161ac9f336a2bbbd6b61a961f285b457c1df8ea1ac3e31fff44f1bbd"
    sha256 cellar: :any,                 arm64_monterey: "5bd08c05a8b02dbc0788c812abda0d0ddf30003549a3ec693ea3e42704b8ffa6"
    sha256 cellar: :any,                 sonoma:         "67aa251362dc04b221fd476e2b0e54be019577bba22bb47c841e8867dc7df179"
    sha256 cellar: :any,                 ventura:        "d1d10bf61acd6dd5e790bd025ee16883e9caa60f1dd65ba4d1c55984b6af9990"
    sha256 cellar: :any,                 monterey:       "bbe54741dc51d3d47b27b8f740b9eef68475ee4898fc824f81d82516e92167ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48309e0ff39b617745169c9213f3fb3629a022469b8805ba924cf217bfa0a224"
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
