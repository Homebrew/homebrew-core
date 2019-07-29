class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://sourceforge.net/projects/unnethack/"
  url "https://downloads.sourceforge.net/project/unnethack/unnethack/5.2.0/unnethack-5.2.0.tar.gz"
  sha256 "1dc6a47e79229265b14ccb224ef151b2b04b327ab1865ae770078b5e8c724119"
  head "https://github.com/UnNetHack/UnNetHack.git"

  bottle do
    sha256 "c95ffced18c9be00207e55c4d592f477cd5975fd04412115de66629d74e66088" => :mojave
    sha256 "4648259b51fa627ee3ad0ef01b5040e573741f9528385d8c04d8b6354ec745c8" => :high_sierra
    sha256 "4ccafeafee0cd1e9cc7705ee312101229748100ea32b5cb1c7c63b29ed1d7742" => :sierra
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
