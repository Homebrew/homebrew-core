class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.7.0/scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a7a9b2ad9338b06651f10ad2df98a3f8c4632b3d3131473c3e5136d7a92b0c9d"
    sha256 cellar: :any,                 arm64_sonoma:   "8b78826af926de9ec347542ec780fc66f159eb5f3b36660f6d40b35a832e9352"
    sha256 cellar: :any,                 arm64_ventura:  "d6a3d97e6819c362dac3207848b99446363fbc4084056a7b5fe8bfa01de3a3cd"
    sha256 cellar: :any,                 arm64_monterey: "51613aeb80f1f322075be0edfaf0e70dd0f16eb66946205db21f4acab942174d"
    sha256 cellar: :any,                 sonoma:         "3c98ef75a43b652e83d64c071103f963966c5498bb07f578a5cc3c196dc861e2"
    sha256 cellar: :any,                 ventura:        "492a9820bcfd434d53c783a7270d73e9c3d4ae851f869bdff678ed371a67821c"
    sha256 cellar: :any,                 monterey:       "d0b67c7264294d61a499a6474339a65bb7dce29f5f8cded3fdb0f78a588a7063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ece3329da2323817bd776851b93076fb3dd5997884a43122397f4dcc487dfc"
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
