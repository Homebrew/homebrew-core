class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz"
  sha256 "075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694"
  revision 2

  bottle do
    cellar :any
    sha256 "62dcd0007d8152341d428e1ec5d60216e68f06f59c58afc5ace1420a7f53f5d7" => :high_sierra
    sha256 "8c76984071738130c96d07cc0ca03369b651102ff2cdc0992cf37539d46ca045" => :sierra
    sha256 "773d79a09235083d24ea1ef3da98324cc2dcde55815543cc50c49d4f68b5b370" => :el_capitan
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
