class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.12.tar.gz"
  sha256 "6101bdf937716be9b019c721b28b45d21efddd1ec19ac935aad351c55bd6f83d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3262f996e9a28127079744cd55830b085ba8708cfed45b70478e5d2cfbfbe19c"
    sha256 cellar: :any,                 arm64_monterey: "ec1b7d6bd9f582f6734dbc40d09c04b5fc13240a46c1fb582a749d820413cdc2"
    sha256 cellar: :any,                 arm64_big_sur:  "1f8ce6a1f4d7679a248834ca2bf9811d4ccca1c1c873db22f99ff2277e6e6978"
    sha256 cellar: :any,                 ventura:        "d864ab0b5a3ce002e9bca98e7318b8ecc969c1c06a972ba75242569b173d4ad9"
    sha256 cellar: :any,                 monterey:       "8ddaa7ab87c4f7ee9d0a148fde67e01db7a21e390f06dd33d1d71dbf2194a206"
    sha256 cellar: :any,                 big_sur:        "cfd807697adb24053880f20dfc6bf05f47940e2ddd437e19932df2a8ec068ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fdf32278d5b275064da0c1b8194ca3e0bdcee40555c696cf37db9eaf553452c"
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.4.1.tar.gz"
    sha256 "949438b558bdca142555ec482db6092eca87447d23a4fb60c1836e9e16b23ead"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("gensio").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio",
                            "--with-python=no",
                            "--with-tcl=no"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    if OS.mac?
      # Patch to fix compilation error
      # https://sourceforge.net/p/ser2net/discussion/90083/thread/f3ae30894e/
      # Remove with next release
      inreplace "addsysattrs.c", "#else", "#else\n#include <gensio/gensio.h>"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-p", "12345"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
