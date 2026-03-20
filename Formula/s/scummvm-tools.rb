class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d28a7955a87d0efcbf04f382122f517576a039283383c6f22ddb6298b00edfad"
    sha256 cellar: :any,                 arm64_sequoia: "d5a203cafe61c31df5426ad96fc271aab5447c8bbe0c5ab95778c2cebb996859"
    sha256 cellar: :any,                 arm64_sonoma:  "b3a3b0db5b6a28c42aec199437c73c5b466d85349199999b4a2dd6e7cad6815a"
    sha256 cellar: :any,                 sonoma:        "1e10ac9dd30c9d189516e5a3fc756c1e316637b3739b831a3d025a4e89fdb31f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb7c611303c6cb34706789248e67fe70ec974ce5e0fe76920a6b95ed2888fff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2882fe5bdb6fc4b5a9eca98543fc23a47ec15a8ad352dfbe38387f5649882d"
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
