class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 9
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50d8ffe794a9964152bdea3d644cdb767ce3079188e19f0de9a3b1c24421c6e4"
    sha256 cellar: :any, arm64_sequoia: "e853d26598617e90007df486edca6e605807d7f6907521824e4511ed12a6c9e4"
    sha256 cellar: :any, arm64_sonoma:  "4a639a517509d37e91bda0648e602e1d84a5b3fd0a617d1a1779cf419ac96866"
    sha256 cellar: :any, sonoma:        "b798c2ab29611357294932f855b796752fdaa35e38e1a6022e302ab55e0c994b"
    sha256 cellar: :any, arm64_linux:   "b91848b334c016d83a1448a91222a77771684eaa41aa6c085739009d3b8f1ad7"
    sha256 cellar: :any, x86_64_linux:  "1c1103f04abccbaad16ae1b72bb2460fa4594ca5fc1400d123026ff3959d35b5"
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
