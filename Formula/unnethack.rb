class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://sourceforge.net/projects/unnethack/"
  url "https://downloads.sourceforge.net/project/unnethack/unnethack/5.2.0/unnethack-5.2.0.tar.gz"
  sha256 "1dc6a47e79229265b14ccb224ef151b2b04b327ab1865ae770078b5e8c724119"
  head "https://github.com/UnNetHack/UnNetHack.git"

  bottle do
    rebuild 1
    sha256 "49f11fd0bf05d04c18826206e98dda97cf9cb0702ffa38f97b6062a4f29c356b" => :mojave
    sha256 "2a81f9eaedd5ec9d058e458eade6d84d4186e46887af68e45ea85aded10528f3" => :high_sierra
    sha256 "0ef61a7b3cf7d0b167ea3db9464cc10855d5131383b2cec1d87ac8f0afeae6f8" => :sierra
  end

  # directory for temporary level data of running games
  skip_clean "var/unnethack/level"

  def install
    # directory for version specific files that shouldn't be deleted when
    # upgrading/uninstalling
    version_specific_directory = "#{var}/unnethack/#{version}"

    args = [
      "--prefix=#{prefix}",
      "--with-owner=#{`id -un`}",
      "--with-group=admin",
      # common xlogfile for all versions
      "--enable-xlogfile=#{var}/unnethack/xlogfile",
      "--with-bonesdir=#{version_specific_directory}/bones",
      "--with-savesdir=#{version_specific_directory}/saves",
      "--enable-wizmode=#{`id -un`}",
    ]

    system "./configure", *args
    ENV.deparallelize # Race condition in make

    # disable the `chgrp` calls
    system "make", "install", "CHGRP=#"
  end
end
