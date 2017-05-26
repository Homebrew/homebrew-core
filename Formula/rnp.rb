class Rnp < Formula
  desc "The Ribose fork of NetPGP."
  homepage "https://github.com/riboseinc/rnp"
  url "https://github.com/riboseinc/rnp/archive/3.99.18.tar.gz"
  sha256 "b61ae76934d4d125660530bf700478b8e4b1bb40e75a4d60efdb549ec864c506"
  head "https://github.com/riboseinc/rnp.git", :using => :git

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    # Generate the configure/Make files. Ideally this won't be necessary
    # in the future.

    mkdir "m4"
    system "autoreconf", "-ivf"

    # Configure, make, and install.

    openssl = Formula["openssl"]

    ENV.append "CFLAGS", "-I#{openssl.opt_include}"
    ENV.append "LDFLAGS", "-L#{openssl.opt_lib}"

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-openssl=#{openssl.opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"netpgp", "--version"
  end
end
