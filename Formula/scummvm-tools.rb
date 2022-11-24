class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.6.0/scummvm-tools-2.6.0.tar.xz"
  sha256 "9daf3ff8b26e3eb3d2215ea0416e78dc912b7ec21620cc496657225ea8a90428"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39044665ae98bd82a5e96e2cb16052bec48f0a9d19fc5dd4a648aad75bfd677d"
    sha256 cellar: :any,                 arm64_monterey: "670786a12ff02653d9d2d77a1faa27683abe48c431f98b90106b88e312f74d75"
    sha256 cellar: :any,                 arm64_big_sur:  "67f85a329d977f16bee1d7d202ec51b5c0969b3988df390ef6543824e98bef13"
    sha256 cellar: :any,                 ventura:        "97e680e16deb7b3986f18596a077795b572bec15dc33233a914a7b0e7db30e18"
    sha256 cellar: :any,                 monterey:       "3890ecaedde0c7d925a6d5651b9ed928f580d18f836dc0d872349659acdc5745"
    sha256 cellar: :any,                 big_sur:        "06e6c4938c5bead888afdc9ac109e455b662cc3c07f7ddc67a6baf7f58f8b93f"
    sha256 cellar: :any,                 catalina:       "54d224c68f5e743ff59244dbed1509f188d401e00b4c9a798ae5a269c1a00a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c10e42742299c7d192c80aa3fee69e560879f509a307db2e35a5a30ae927baf"
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
