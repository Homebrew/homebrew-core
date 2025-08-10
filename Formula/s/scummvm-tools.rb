class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8742385ef38f2c949961d1a4c41e7c13f55d07db59b06283ca949ec095bf916"
    sha256 cellar: :any,                 arm64_sonoma:  "6ec40e4551d67af6dc48bee3b60d74e5cb3abcdaf1d29d7d674d9abaf6eba5aa"
    sha256 cellar: :any,                 arm64_ventura: "95dc943e79e1884cd589fe1db27952724318081bf3c1685972e91c1ea2bf35bc"
    sha256 cellar: :any,                 sonoma:        "8df1ef3d5334bcf8173480bd0fd7393045b78985447c558a979bd4e0a1a626b5"
    sha256 cellar: :any,                 ventura:       "e52530e7a1069a23c57b0f2e51e847a72bcdc9474f4d9e4d2620443fe3f0bebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfba1b75ce550ef63b147a7a7a438fe7992b48de9d99310d1bdf9c1b78c24c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d27784dca224621fef8c52ae30d4f9014b5a0d38a3ba6817a64f4b36ff04da"
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
