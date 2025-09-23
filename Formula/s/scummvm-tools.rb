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
    sha256 cellar: :any,                 arm64_tahoe:   "f127057fdb6f7cf205adaf488d4bd1ac333e5594b1744e3a2781c54f0e23b444"
    sha256 cellar: :any,                 arm64_sequoia: "ef18a6418ce11c2673af53dcc1b2a21b9040545afe110d2d99e0c88170a2c398"
    sha256 cellar: :any,                 arm64_sonoma:  "8180c9d89327d44d353e8f0684b75a72156fee9d245a12f8f3620b41096a25be"
    sha256 cellar: :any,                 arm64_ventura: "f90ccd5ce750fecac29157dfaada5171a890c5dc8b6ae194adc2f829b3894526"
    sha256 cellar: :any,                 sonoma:        "0eaca449b6111e14fc1e564137c67445d7d96fe241499f70e7b75d57e8933db2"
    sha256 cellar: :any,                 ventura:       "6b5c2b0112b3dc1e0fecbbcdd11bb67bec5dca0c39f12d364925d0e6a0b6fabd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0174937d75ac25ec4a7566e423cbc8486393a6a2fcb24e264ce803c0541e8a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b267aef34dc479086f9f0cf9e1ed1188a9dcb42fdb0320c826dc4d658bf16e7"
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
