class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.6.0/scummvm-tools-2.6.0.tar.xz"
  sha256 "9daf3ff8b26e3eb3d2215ea0416e78dc912b7ec21620cc496657225ea8a90428"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "499de191275bbf936f8d9e246976e6188b1ce9d52f564af3f5c6c9777d632589"
    sha256 cellar: :any,                 arm64_big_sur:  "fbd80c2985dfb8755de5ad94f4933f025f7efb1ba511e0415e26c3c8ee80c595"
    sha256 cellar: :any,                 monterey:       "e55b51da1a0452c6d55952961e3751ce71ec09fda9f19183f3f166a3463c0822"
    sha256 cellar: :any,                 big_sur:        "21028952a2a0b56a2a03b7b7d547a454d8659ee2caf0653b97da2f1d483ae15a"
    sha256 cellar: :any,                 catalina:       "ff34a6f37530ec0d77ba18dbcd9cf0cc4f4fd96e467a3acdd3db0c360a94419a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e81d861d2d5381e0755b683d50412d905fd7bd4e124cd146cba0c4e6f74bfc1"
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
