class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.1.tar.xz"
  sha256 "60492a19b44e6cf9a3ddff68325b333b8b52b6c59ce3ebd6a0ecaa4c5117e84f"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]

  bottle do
    sha256 arm64_ventura:  "f1c32579a284798da77cecf823ef86d41e70e91e86e5cfa5ea09e2b4e4b70a7e"
    sha256 arm64_monterey: "b0b3c6d674a5ddc13707ac4af2ba34745b7dea8048b6b12034f3685cb017cadc"
    sha256 arm64_big_sur:  "1b806803757b40e4ffed44f68364cb45386ff96d467fa94d6d776b1f41c1d5bc"
    sha256 ventura:        "7e8d8823d3666212fbedaa7725dffa7f1fc6e29005b0cca7eb6bd6cf1ecd5130"
    sha256 monterey:       "0c66175a5324b3a5a31bfbe2b6c2154666cbbddd1203182a661f6f6cb1095799"
    sha256 big_sur:        "237a36c3eb5250d0b71d5cac628c364d2a753174ad8b891cdb1f548b60c182b7"
    sha256 catalina:       "3d52e89f1e08a9d93462d2008289379784842ff8caa538eeaf653ea689500993"
    sha256 x86_64_linux:   "27177c2a258f719de1236fc0eafa5e45021f7997e332dd9d345c28d0c4354c36"
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
