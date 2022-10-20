class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.8.tar.gz"
  sha256 "e5620975523059a38709bb53c0567600adbbcb8011066a2d2fe1b4db9efe0ba3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22b2605d46b4a94c20ce31aaaed980ea376675b8882d49beae4bfe8a7869d803"
    sha256 cellar: :any,                 arm64_big_sur:  "274e148eb8f808db0bc619590862908a6595ab3aacb90393ea378ff0c63213f2"
    sha256 cellar: :any,                 monterey:       "f656e0998f09c08824075e1264c817f30bb9b685edf9902d4b108b79a95aa4be"
    sha256 cellar: :any,                 big_sur:        "a73f13deaf0d2825d9d3b66df9a1d5000d3291986598ad09b95af396a47c4c32"
    sha256 cellar: :any,                 catalina:       "92363d900b4f7a3bcce1d2ac597e7316101f81060f1bad3c2bb391d2b6393753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd58a00c3d1181f32723e09bfd4711a3a24200803593da8e1023d5e3798b6108"
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
