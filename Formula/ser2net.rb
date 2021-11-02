class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.4.tar.gz"
  sha256 "c714d6777849100b2ca3f216d1cfc36d4573639ececc91d5c7809dfe27c8428e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "be5488df8e6b9e4fd6750ff8b0156ff74bf77e1c65789bab0466fefd03c1f391"
    sha256 cellar: :any,                 arm64_big_sur:  "1845d6644d7cd518e8b1c7f7abd4ab1d6515eb482690a062b8e17ddbc6eb7c4c"
    sha256 cellar: :any,                 monterey:       "f6cac316c6081bfef01bcdd90eb4f7ac4f1b90232400b067d048e890facb992a"
    sha256 cellar: :any,                 big_sur:        "03feeb3d9e3049231fccb29a8ca8bc7d79c0e4839381d1340c45cf932ddaea68"
    sha256 cellar: :any,                 catalina:       "21a9c4c0a980b74a864c7db0782f71786e133cc2e3d62411fa9ea0f99c38e0b2"
    sha256 cellar: :any,                 mojave:         "a2abbe3f823de5e70a863f521e63fcb079801b22d653f4bdb26a775c97fa4289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4726875c7f661b925b6fbd7d82eeaf89fd4b91a28ba34377860c8ebbb3f999"
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
