class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.tar.xz"
  sha256 "6d111cbe4d55b336db2f1fbeffbc65b89908704c01136371d32aa9bec373eb64"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]
  revision 1

  bottle do
    sha256 arm64_monterey: "c9653e2676398fa31ef966b4708dd77598d940567ae98bf8a358bf6e3f9795d3"
    sha256 arm64_big_sur:  "af364bc9ec694952b1d7a24754c06b42dbf29a6d177b6a17d2f6d0142b9c996f"
    sha256 monterey:       "1d3d53424843429c548fbbe26708ff3fc70c61fa77e431f15586ec85a86e43f5"
    sha256 big_sur:        "16e6c5fc7d5f68666b8d418180d76cf6df8ac085935836747e9ba4a81a3684cb"
    sha256 catalina:       "9a4c50aca114732ebdca292bff3d11074824dc7d8991421dc9d57ff35d8c5bc6"
    sha256 x86_64_linux:   "79b4830d6c2b45d991a81915e7f340c21ddc7e6c4b189916791aaab296a30517"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "asciidoctor" => :build
  depends_on "gettext"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Everything in following macOS block is for temporary patches
  # TODO: Remove in the next release.
  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build

    # Fix ./include/statfs_magic.h:4:10: fatal error: 'sys/statfs.h' file not found
    patch do
      url "https://github.com/util-linux/util-linux/commit/478b9d477ecdd8f4e3a7b488524e1d4c6a113525.patch?full_index=1"
      sha256 "576c26c3d15642f1c44548d0120b192b855cceeebf8ad97fb5e300350e88a3f7"
    end

    # Fix lib/procfs.c:9:10: fatal error: 'sys/vfs.h' file not found
    patch do
      url "https://github.com/util-linux/util-linux/commit/3671d4a878fb58aa953810ecf9af41809317294f.patch?full_index=1"
      sha256 "d38c9ae06c387da151492dd5862c58551559dd6d2b1877c74cc1e11754221fe4"
    end
  end

  on_linux do
    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  def install
    # Temporary work around for patches. Remove in the next release.
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    args = %w[--disable-silent-rules]

    if OS.mac?
      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-libmount" # does not build on macOS
      args << "--enable-libuuid" # conflicts with ossp-uuid
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
      args << "--disable-cal" # Conflicts with bsdmainutils
      args << "--without-systemd" # Do not install systemd files
      args << "--with-bashcompletiondir=#{bash_completion}"
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system "./configure", *std_configure_args, *args
    system "make", "install"

    # install completions only for installed programs
    Pathname.glob("bash-completion/*") do |prog|
      bash_completion.install prog if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
    end
  end

  def caveats
    linux_only_bins = %w[
      addpart agetty
      blkdiscard blkzone blockdev
      chcpu chmem choom chrt ctrlaltdel
      delpart dmesg
      eject
      fallocate fdformat fincore findmnt fsck fsfreeze fstrim
      hwclock
      ionice ipcrm ipcs
      kill
      last ldattach losetup lsblk lscpu lsipc lslocks lslogins lsmem lsns
      mount mountpoint
      nsenter
      partx pivot_root prlimit
      raw readprofile resizepart rfkill rtcwake
      script scriptlive setarch setterm sulogin swapoff swapon switch_root
      taskset
      umount unshare utmpdump uuidd
      wall wdctl
      zramctl
    ]
    on_macos do
      <<~EOS
        The following tools are not supported for macOS, and are therefore not included:
        #{Formatter.columns(linux_only_bins)}
      EOS
    end
  end

  test do
    stat  = File.stat "/usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, ((stat.mode & (2 ** index)).zero? ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end
