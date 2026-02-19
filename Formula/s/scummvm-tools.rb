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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "64c54efc7b79c018abb5443b6d3e05b1d51997696847bbe9bee1af22d0745213"
    sha256 cellar: :any,                 arm64_sequoia: "9c4cdde35d00c906263b4ae6d8cda36fafdfd35f8395b894eb82394becce3163"
    sha256 cellar: :any,                 arm64_sonoma:  "749333f5526e454f68161b94259e62424c7a484153419158a67f88ee805df10f"
    sha256 cellar: :any,                 sonoma:        "73361f10d4d64cd990a2ca51ff05ac062822256c8366d6805b355eb3a282984f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec56e1098e866d84f5ed7cd50935211b5061227731a337eda32e8b3f2d2ef8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba62909fb5a479ffc2c3711d1e35aa27534d3d0dfcad1db1eeeede1f12e33f06"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
