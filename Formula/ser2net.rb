class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.9.tar.gz"
  sha256 "bcb8ae31d00c6b4392d1cd1c9ecc9390a8b241029c42c5eb951af090edaf56db"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8548c7f69b48ade034479ddb41b1dcae0f0cd7ae9279dde4389f3a322ed3cfc5"
    sha256 cellar: :any,                 arm64_monterey: "f3ae611ea890e35d65f9ec9583c8bce9c88c60aed8f4f4b241720e9e06878672"
    sha256 cellar: :any,                 arm64_big_sur:  "fb39b2fa049859b4c9f7333e7d796b6896b2803d4605730a46647982c8eb47bc"
    sha256 cellar: :any,                 monterey:       "4f51bdc3a9a062225dd65c923ae845387e562566848f0c62407b89c1aee6d23e"
    sha256 cellar: :any,                 big_sur:        "cbb9f1c956e7385ec52459aa1e5151b3d0cd20bc4f1829757d2c479ce3a75107"
    sha256 cellar: :any,                 catalina:       "8379677874b4b2b14821d95d757159f7a8484af7cdac223a3b0cf80b02e95a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f704be456080fbcf9bceccf797a519069c5d592dda2e32f23bae8c162a6373a7"
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
