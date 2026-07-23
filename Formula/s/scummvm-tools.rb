class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm-tools/2.9.0/scummvm-tools-2.9.0.tar.xz"
  sha256 "1b4bbd7a7ccf4584bfc2c0142b7c1b4e5db97c39d8d214757c72d50e0905b71d"
  license "GPL-3.0-or-later"
  revision 8
  head "https://github.com/scummvm/scummvm-tools.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f9a3b5c6db0fdd0bd007bad647309b11ad42c05527556d40b282e9ee2995592a"
    sha256 cellar: :any, arm64_sequoia: "9ee66677808c3047c7e499c67c7d26f52d5a9af2b213455eff2853ef57e292ca"
    sha256 cellar: :any, arm64_sonoma:  "8d034d4919e0f96ba5340c2f1a22b84205543ba7c40fd0051f58e466c09eee7c"
    sha256 cellar: :any, sonoma:        "e069788d6e2fc336c2e4456d6f4aa1e25c54a7fa325d6bb99293f4a8cef6784d"
    sha256 cellar: :any, arm64_linux:   "76fa2b8585858308313032c7b36ec51a67725c7100534596974b752f9aa3e1ee"
    sha256 cellar: :any, x86_64_linux:  "c5a4f78dc5ac046697d0f23b2f3b6df2302bf7b3978a97642d4c70ddf608b2a8"
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
