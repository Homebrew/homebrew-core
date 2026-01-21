class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0d9ce1db6aa5f90e5ab793a5735b72a539ec1ef17537c02923e95557a4d687c"
    sha256 cellar: :any,                 arm64_sequoia: "98c8e8d7f906f5a137f252a3ae78bc3bcd17675feecad98e1716be21b41c07ef"
    sha256 cellar: :any,                 arm64_sonoma:  "5b51e517b66e0cafa867418ed4e4556f38a5995f43341ce84e187d0b93b4c97a"
    sha256 cellar: :any,                 sonoma:        "47767c0db65bd642dffbeacd583481a054347ac263743b7ce6ee2cc0117f1c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd405eb41890990dfb3ccc1064d6e0ed64de62568e624a6bd09d56d1aec2034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c0130120333cafa9ec0074e98057ec2d69539f74551cbbc63631c1fbd0b526e"
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
