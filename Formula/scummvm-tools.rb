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
    sha256 cellar: :any,                 arm64_ventura:  "4e619e2bc6a07bd48a2b5f06e8a5a47d097ccf4f4dd4fd824cb1ba572f23be57"
    sha256 cellar: :any,                 arm64_monterey: "07f7fb8a90ef1b15db4d51fb7c3be66b77ea9dbd812ab01affe6cd64b54ff5c9"
    sha256 cellar: :any,                 arm64_big_sur:  "a1b220d3eef9dfb4c2fef1bcbec75cec66adb77c4b9739eb78507a80a6c4731e"
    sha256 cellar: :any,                 ventura:        "ea2aa2846235d6274406c35262c0a6be9301b6cd69a1505a9490a9690a791a09"
    sha256 cellar: :any,                 monterey:       "ed2f45d2b562c53ec9349d011254bf4d5018a8171bf34abc4bfa9eca52338c5d"
    sha256 cellar: :any,                 big_sur:        "f77c68b0723f6712ded8f585d94788c925b66accc06b9d6f6ef5666919416d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4028199cc2ab015357d267fd9f35b76a988a587e9d4523d582659b763b4537df"
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
