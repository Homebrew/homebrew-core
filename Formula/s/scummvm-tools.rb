class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46759130016955bb830b13ac208690894f44c60bb2785e6565602641eb68002f"
    sha256 cellar: :any,                 arm64_sonoma:  "491fb7be5cb1560ccb97582995a9ea1cadeb486c0b4d9696d123ad991cb0f3fe"
    sha256 cellar: :any,                 arm64_ventura: "4bd75f5794891f0583f3f6673adfdd4bdf169448bde8dca3a94afddc11b271bc"
    sha256 cellar: :any,                 sonoma:        "c9b8494958a9632d4a672f66ea776eea90bad594b68f4710c9848294b25f2e78"
    sha256 cellar: :any,                 ventura:       "9c7148d9c1ce60a3ba44633d758d3c4153bf7660f79f24ebdaeed4ed1a84b902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cecc8be45d810f918b1d299bc729d1c15ec2a35537f215068165e5a846e81671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f8366f66c75484d67f6d626d123945f13e89bac0c5e3087c77d89caacbaed6"
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
