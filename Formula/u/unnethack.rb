class Unnethack < Formula
  desc "Fork of Nethack"
  homepage "https://unnethack.wordpress.com/"
  license "NGPL"

  stable do
    url "https://github.com/UnNetHack/UnNetHack/archive/refs/tags/5.3.2.tar.gz"
    sha256 "a32a2c0e758eb91842033d53d43f718f3bc719a346e993d9b23bac06f0ac9004"

    # Apply upstream commit to fix build with newer bison. Remove with next release.
    patch do
      url "https://github.com/UnNetHack/UnNetHack/commit/04f0a3a850a94eb8837ddcef31303968240d1c31.patch?full_index=1"
      sha256 "5285dc2e57b378bc77c01879399e2af248ef967977ed50e0c13a80b1993a7081"
    end

    # Fix implicit `ioctl` function declaration. Remove with the next release.
    patch do
      url "https://github.com/UnNetHack/UnNetHack/commit/33a3bb6539452875a88efbf6da0148a1cccc00c1.patch?full_index=1"
      sha256 "07e1bb472c4f20957dafc6cfc49fcfd3178a5e04fcebf93a4fc7922ec8c0a963"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]\d{6,8})?)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "95679ab2628590f991ccb63e169583d400bfadc242a7cc87cf914e733104f1f1"
    sha256 arm64_sequoia:  "fccec5070c4616fe421556ce507d015687ccdcd4da2681b2f8cc676dd4e7df9e"
    sha256 arm64_sonoma:   "1c6320df0cd991aeb79ab344592d38726b9844cf5427c15b8a24d3195f2864b7"
    sha256 arm64_ventura:  "dce7d673a3f638fe97b4757fe3d78cb61b5fbdd1fec8b1f536e1295179195e91"
    sha256 arm64_monterey: "05c4befbdb39343bd07d991ea4d3b048215098aea8af4239e0c6ecef27deb330"
    sha256 arm64_big_sur:  "5b4386eee78f20075e693b6ad437df496c8c914518161d8901991c1c4a6ee1f9"
    sha256 sonoma:         "c3a805f2af26f6941d60c7366f6c4f05fe67851fbe61c30fc2f73d05963b07a9"
    sha256 ventura:        "25c86b07ec5d9a182bf5a55a607bf232297585269d68ba7c6abcdd71eea6b8fa"
    sha256 monterey:       "c93c7e1e75f40ea747049d51072aefee9604e92c2643921aaa251ca35a08b2fc"
    sha256 big_sur:        "45d58053580ccdf9b65510768136206b71453b3457f23240a6dc592f817a6145"
    sha256 catalina:       "5a1aea5f715d4c8892be4a5e76d60157da6637559a0055c41ea8024284807e91"
    sha256 arm64_linux:    "fe7c3c84361536ea594420bcd89757bac4450462dfe0b9a2dd47e7626f3ec1d8"
    sha256 x86_64_linux:   "31307b80abcdcf33c36d3716969e3a2b8202d80e6ea79574f3689d21eb3faac5"
  end

  head do
    url "https://github.com/UnNetHack/UnNetHack.git", branch: "master"

    depends_on "lua"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "util-linux"
  end

  # directory for temporary level data of running games
  skip_clean "var/unnethack/level"

  def install
    # Workaround for newer Clang. Fixed in HEAD but requires large patch
    # Ref: https://github.com/UnNetHack/UnNetHack/commit/00dd95ccad390e72d6a4fb2e058df48ed509b564
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    ENV["LUA_INCLUDE"] = "-I#{Formula["lua"].opt_include}/lua" if build.head?

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
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args
    ENV.deparallelize # Race condition in make

    # disable the `chgrp` calls
    system "make", "install", "CHGRP=#"
  end
end
