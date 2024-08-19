class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.7.0/scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd8d7d1226016f2683d1a9ad90ec96ac1aa84772ed0ffb38efee4176177a264f"
    sha256 cellar: :any,                 arm64_ventura:  "7759a1057795e716c9077985a22fb32e5130052fbd76887802a99cdadb463338"
    sha256 cellar: :any,                 arm64_monterey: "1d5c367ee6643415ec06855c3f55e60a9b3dda5acba06e8b70fe1f0e7df5297e"
    sha256 cellar: :any,                 sonoma:         "6aa20238aaca1a0e815a2bc48471f50b7bb362fe778e31683f3404675cb71899"
    sha256 cellar: :any,                 ventura:        "8c21f8eae874f7fbfa4abd82a4d164bac9acce7ef824c0a1ee5700c3ffaba2c0"
    sha256 cellar: :any,                 monterey:       "ba08176b0785655d60c87673475eafb63404658be144767be55836e504cd7253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be51abe51e89d175f338cfc0b5545a2c9bd3e737da4296384d294e2bafe87d49"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets"

  uses_from_macos "zlib"

  def install
    # configure will happily carry on even if it can't find wxwidgets,
    # so let's make sure the install method keeps working even when
    # the wxwidgets dependency version changes
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)?)?$/) }
                    .to_formula

    # The configure script needs a little help finding our wx-config
    wxconfig = "wx-config-#{wxwidgets.version.major_minor}"
    inreplace "configure", /^_wxconfig=wx-config$/, "_wxconfig=#{wxconfig}"

    system "./configure", "--enable-verbose-build", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/scummvm-tools-cli --list")
      All available tools:
      \tcompress_agos:	Compresses Simon the Sorcerer and Feeble Files data files.
      \tcompress_gob:	Compresses Gobliiins! data files.
      \tcompress_kyra:	Used to compress Legend of Kyrandia games.
      \tcompress_queen:	Used to compress Flight of the Amazon Queen data files.
    EOS

    assert_match version.to_s, shell_output("#{bin}/scummvm-tools-cli --version")
  end
end
