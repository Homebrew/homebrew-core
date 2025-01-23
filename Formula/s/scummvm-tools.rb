class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9f8d04daac9c26a48ff80e3ce087d12cb3b5b8bdebab9884765c950de4d30bf4"
    sha256 cellar: :any,                 arm64_sonoma:  "e07ba39dd7a18914540bc691a69386e9f0010a45449577e87d6ec85b69ac81c0"
    sha256 cellar: :any,                 arm64_ventura: "7cc02f042e2857885a37a690963828b1d86299e971c0e6a7fe5b21dc4570c891"
    sha256 cellar: :any,                 sonoma:        "0d76af780aac37fec4ddbe3839c0967e75c228888e0d5dd1ac1558f2971aa422"
    sha256 cellar: :any,                 ventura:       "4af72525fa2059800f33b2ae392dcca1686bfb4f3275ca009b3180af353e74f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529873130d47d9b1d37b903881307e03f73c83d37125b40381307c40b105332d"
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
