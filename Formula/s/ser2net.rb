class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.4.0.tar.gz"
  sha256 "2abef00ee6481b072bdc290422983b2374cee1ccb5a565e9b378ce7428b074dd"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "b77d561beaf06fc685c8d6a27efbfc5171d7b9292571fa062b0700021b1af215"
    sha256                               arm64_monterey: "42b8b9db1deeb895d7c0463a17dc22cbcc3ba84a36d638e089fa8114c2f4e285"
    sha256                               arm64_big_sur:  "7582b4bfebd5fe97ce7e44b7603385e4171b695e57fab40981c9af4fbdd641e4"
    sha256                               ventura:        "3fe735656ff4c83aba4f273c84594a97845d80004dd103cb376c2a0a87258187"
    sha256                               monterey:       "cb4401f9150a09f94271ef4d9ed19afeb7a98d000d957f9932afe3643aba84e5"
    sha256                               big_sur:        "2e048121a8477cd717526d5f4f07160f24a0a21b479a26e56ece3433b22ba7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "892751ba4244666c52876133f6a6bb0c74dc792d102aa9041ebd6331a3e8dc2b"
  end

  depends_on "libyaml"

  # pin to use gensio 2.4.1 due to arm build issue with 2.6.7
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
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v", 1)
  end
end
