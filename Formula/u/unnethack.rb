class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://unnethack.wordpress.com/"
  url "https://github.com/UnNetHack/UnNetHack/archive/5.3.2.tar.gz"
  sha256 "a32a2c0e758eb91842033d53d43f718f3bc719a346e993d9b23bac06f0ac9004"
  head "https://github.com/UnNetHack/UnNetHack.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]\d{6,8})?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "dce7d673a3f638fe97b4757fe3d78cb61b5fbdd1fec8b1f536e1295179195e91"
    sha256 arm64_monterey: "05c4befbdb39343bd07d991ea4d3b048215098aea8af4239e0c6ecef27deb330"
    sha256 arm64_big_sur:  "5b4386eee78f20075e693b6ad437df496c8c914518161d8901991c1c4a6ee1f9"
    sha256 ventura:        "25c86b07ec5d9a182bf5a55a607bf232297585269d68ba7c6abcdd71eea6b8fa"
    sha256 monterey:       "c93c7e1e75f40ea747049d51072aefee9604e92c2643921aaa251ca35a08b2fc"
    sha256 big_sur:        "45d58053580ccdf9b65510768136206b71453b3457f23240a6dc592f817a6145"
    sha256 catalina:       "5a1aea5f715d4c8892be4a5e76d60157da6637559a0055c41ea8024284807e91"
    sha256 mojave:         "84267cd44f073a41058516e7a8937da6b8b0f16e3500b0fd10ab0fedad77a5ce"
    sha256 high_sierra:    "47228cb416afe4d7e9ab31a2b85914e6b27f77e88340f7ef174bb2d9dd3ea2bb"
    sha256 x86_64_linux:   "31307b80abcdcf33c36d3716969e3a2b8202d80e6ea79574f3689d21eb3faac5"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "util-linux"
  end

  # directory for temporary level data of running games
  skip_clean "var/unnethack/level"

  # Apply upstream commit to fix build with newer bison. Remove with next release.
  patch do
    url "https://github.com/UnNetHack/UnNetHack/commit/04f0a3a850a94eb8837ddcef31303968240d1c31.patch?full_index=1"
    sha256 "5285dc2e57b378bc77c01879399e2af248ef967977ed50e0c13a80b1993a7081"
  end

  def install
    # directory for version specific files that shouldn't be deleted when
    # upgrading/uninstalling
    version_specific_directory = "#{var}/unnethack/#{version}"

    args = [
      "--prefix=#{prefix}",
      "--with-owner=#{`id -un`}",
      # common xlogfile for all versions
      "--enable-xlogfile=#{var}/unnethack/xlogfile",
      "--with-bonesdir=#{version_specific_directory}/bones",
      "--with-savesdir=#{version_specific_directory}/saves",
      "--enable-wizmode=#{`id -un`}",
    ]
    args << "--with-group=admin" if OS.mac?

    system "./configure", *args
    ENV.deparallelize # Race condition in make

    # disable the `chgrp` calls
    system "make", "install", "CHGRP=#"
  end
end
