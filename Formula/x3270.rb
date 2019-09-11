class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga8/suite3270-3.6ga8-src.tgz"
  sha256 "a174114ba42fd1644e39adc532d893da8c40692cf46fd5ef02bb83d5704c66bf"

  bottle do
    sha256 "548f8a42e7d672bb6235aa20852e48d9d6a8d09be07017b57f859bcb1e69872a" => :mojave
    sha256 "99c09d8e8adb73201ce8d3f806a82c0e926deb0a7ca6136086bcbedebce42ae3" => :high_sierra
    sha256 "02656ba9619eb9b2bec85d17d542ab9e80e9d9b53932d9ec128bb04a3bdfad25" => :sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
