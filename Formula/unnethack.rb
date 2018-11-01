class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://sourceforge.net/projects/unnethack/"
  url "https://downloads.sourceforge.net/project/unnethack/unnethack/5.1.0/unnethack-5.1.0-20131208.tar.gz"
  sha256 "d92886a02fd8f5a427d1acf628e12ee03852fdebd3af0e7d0d1279dc41c75762"
  head "https://github.com/UnNetHack/UnNetHack.git"

  bottle do
    sha256 "2a93767137077fa4b09b33d21e0c65d862768dd0298c2a8d3477c2e870c7aa05" => :mojave
    sha256 "7da0d5eada4191f5bfd1d3beb6c9d74ed3bc26c54c3ec0d7ff6620592504c131" => :high_sierra
    sha256 "2801362d487c397485b6849a2421c080ddb1261563e77bf64d16aa982843d332" => :sierra
    sha256 "f0e6315f7a8d6135f80290dd20d8e2d80dc8224ad865b073fb71c05771d799eb" => :el_capitan
    sha256 "a6345197d1067ce08e9220bd74701355d19add9c251794b3f12210cded3dce46" => :yosemite
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
