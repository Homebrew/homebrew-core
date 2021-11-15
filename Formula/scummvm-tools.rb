class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.5.0/scummvm-tools-2.5.0.tar.xz"
  sha256 "5cdc8173e1ee3fb74d62834e79995be0c5b1d999f72a0a125fab611222f927da"
  license "GPL-2.0-or-later"
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd81c8f9494ed2e75afe008f2470c2cb0169bad95f5c3156309ea141242e2f72"
    sha256 cellar: :any,                 arm64_big_sur:  "ac030a2d173988dd6adc577588b47fdfa1e506fd1cd8326874ff4e572776a020"
    sha256 cellar: :any,                 monterey:       "d2aae135da5a33814dc9be60191ba27b0003e2aa5de4a4e24d9713316a4d49ad"
    sha256 cellar: :any,                 big_sur:        "3259bdb62e715d7e14892449fb05c7bc2ca95f9717e0de856196168921d61ccc"
    sha256 cellar: :any,                 catalina:       "6657cc2a94b8564c480ef0f1528ec8722939b550f6b0e1f09f7b69cb8b0401cc"
    sha256 cellar: :any,                 mojave:         "aa47046cdfe324770d8bbe51f55ec086273b839dd40d97034506b607e837c431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad140bbc7bd0857a92374964ed1ff268dc620e89ee3ee91767847be76523119"
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
