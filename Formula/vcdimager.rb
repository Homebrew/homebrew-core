class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea434b6d2226040ccaa7388f7ba62cf76e9880b1d217dad26aaa63df2f9c288b" => :high_sierra
    sha256 "59957ad8a3bb455109702642e74331516b78ac4f1e0cb8d1d49c1c511a96dcad" => :sierra
    sha256 "d5ca88f0277e42290bb8f3b1e9e2dc88226393a5fd19161b0db75640d5b2bb09" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  # libcdio 1.0 compat
  # Reported 24 Nov 2017 https://savannah.gnu.org/support/index.php?109421
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3ad6c5d/vcdimager/libcdio-1.0-compat.diff"
    sha256 "65798b9c6070d53957d46b0cac834e1ab9bd4014fab50773ac83b4d1babe00a6"
  end

  def install
    # libcdio 1.1/2.0 compat
    # Reported 1 Jan 2018 https://savannah.gnu.org/support/?109436
    inreplace %w[frontends/cli/vcd-info.c frontends/xml/vcd_xml_build.c
                 frontends/xml/vcd_xml_rip.c frontends/xml/vcdxml.h
                 lib/data_structures.c lib/dict.h lib/files.c lib/info.c
                 lib/info_private.c lib/mpeg_stream.c lib/pbc.c lib/vcd.c] do |s|
      s.gsub! /(_cdio_list_(node_)?free.*, +(true|false))\);/, "\\1, free\);", false
      s.gsub! /(iso9660_fs_readdir.*)(, true)/, "\\1", false
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
