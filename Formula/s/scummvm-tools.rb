class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17c2e47d29d820d952abd8f7c998e6cccc0b76c2db3cedeb2fba9ee4a4d5ca8a"
    sha256 cellar: :any,                 arm64_sonoma:  "bea57948288adcbeebc766c92aa33b55c83cbc655d6c81cd3af696052a80d2db"
    sha256 cellar: :any,                 arm64_ventura: "814637a792eca7f40295e0c8820b05b523b10b9481942c8adc8ebe2cb3557a6d"
    sha256 cellar: :any,                 sonoma:        "2f4e16b6f36872476a378f10dc29a8e3b96c980787a7d61a86f114c11c0ba009"
    sha256 cellar: :any,                 ventura:       "b40f2bb4e3b0c81289ee5bfaf1ef74ffafe63272a953e2c79ad11e92b9d4ce79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c361d6c11cb57770ceaad18334b571b16793e3c806f6ceacb8e271825e5c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71839183e12d5e6c06b327a596e4190955fcefe54c2d0c5c3457988d4aa48c83"
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
