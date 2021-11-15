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
    sha256 cellar: :any,                 arm64_monterey: "0b47f117e2307438dfd293fcdb119afc19265f88727f71c3edec749e69e50e66"
    sha256 cellar: :any,                 arm64_big_sur:  "1ed19ca1d6bb03df612a6c4c08dc5bfa7774fd40907b9531b2d161c555b4e44b"
    sha256 cellar: :any,                 monterey:       "9a608a3f76ca8529eccc91994f337610eb5bfd1afe615d445d5dea958b8b462e"
    sha256 cellar: :any,                 big_sur:        "3fc4d4c18aff806463d20e9bbf04cbaa22b648c24d6297ea80cf85ba7b13246d"
    sha256 cellar: :any,                 catalina:       "042e2c7a57911e1e5510aac5338de9d8f398406104af3ca0c4dfd53e851a7e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc83b8c9ca812a654d5f6e06464c9593322761ac7066ccb79d39fe354d634c9"
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
