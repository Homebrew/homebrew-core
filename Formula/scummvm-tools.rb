class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.7.0/scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a87a4242c56dddc5e962cba10dd676e07d8c613fab40c2bb9ee374a0dc94088"
    sha256 cellar: :any,                 arm64_monterey: "b94d444e7501e888d76a8929c58ec8c19a0a2ba44ddba259e4e0063439810408"
    sha256 cellar: :any,                 arm64_big_sur:  "deafde210201905a6cbd45db5ee0cbb5a9dc2069526ffa84aaa1389a36ce045e"
    sha256 cellar: :any,                 ventura:        "f7f616bc4957826bd52a612f969a159dce28f33eb5126c6217bb711f280e30e0"
    sha256 cellar: :any,                 monterey:       "a1488eebaa651d251530c0bb3f95b90b9d2ebbe6c8e4ec12f0976f898610e5ff"
    sha256 cellar: :any,                 big_sur:        "a542f34bc139a150cdfd43064f080ec4f3b167aebcbbfc7cecf74b17d7e0cbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03adb8e985e8035c59c8f119485de5595902ddb9fce3c31b76de05a4e2391d1d"
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
