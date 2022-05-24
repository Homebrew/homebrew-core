class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.6.tar.gz"
  sha256 "65515c7e9a5289167ae64c4032450904449a87ce20653241022af4f5db2e9510"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5789705f28519128fce9c9e1af6a24aca48f5dee193e9f631065f8372db3a6e5"
    sha256 cellar: :any,                 arm64_big_sur:  "b69ebf939c28e950724c7a1ccca8275014d6815d84eacd1f7040acd652afad31"
    sha256 cellar: :any,                 monterey:       "fdf28ab2fd6407cc937c4dfd656f48fce1f3fd65c58b7cd424e224956ff21f96"
    sha256 cellar: :any,                 big_sur:        "d0f529585752c51874d9719cb57946480546f4fa9117678ffa62f5552a17b212"
    sha256 cellar: :any,                 catalina:       "2a98a1fd8562223f138046fc75a723510a76a2dbabdf1d9187f4bb76681ebad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8894c15d9a8f4dd044d1c39e8eb6f8ae6e230f0fc915d1d3e7120fcc166ee1a"
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.3.2.tar.gz"
    sha256 "0b6333a5546f14396041900bbe5b83575a0e97d200a581a6ddb8fcf6e95adfbd"

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
