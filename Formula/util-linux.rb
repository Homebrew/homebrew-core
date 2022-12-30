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
    rebuild 1
    sha256 arm64_ventura:  "871957ce4150fd4795387c3a0040ef6ba7f804641f2821085867a5cc58496dc7"
    sha256 arm64_monterey: "d55a06518360d9677ab53abfca0566f4cf90330f3798bb99944d208f44787bbf"
    sha256 arm64_big_sur:  "e3d17bcc5a81b040e346b59f73491fd544f33b560dd0586961a9dbe085a54b57"
    sha256 ventura:        "57fca00e8206de00ca97b88d605c6490c82c4f33f8ddf8dd7853841e6023e434"
    sha256 monterey:       "793b7fd5fbaadba11b74130ff3f91d4429b119663692d57862f2a82695f02a9b"
    sha256 big_sur:        "36d7907e0929a843753bc02f76b523189422cd1de66f9c042ffbd8095437159f"
    sha256 x86_64_linux:   "69fb0dd33dc299a156948d60b6d34d0cb23e4cb50f1b2687618ad1765fe0401d"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Everything in following macOS block is for temporary patches other than `gettext`.
  # TODO: Remove in the next release.
  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "gettext" # for libintl

    # Fix lib/procfs.c:9:10: fatal error: 'sys/vfs.h' file not found
    patch do
      url "https://github.com/util-linux/util-linux/commit/3671d4a878fb58aa953810ecf9af41809317294f.patch?full_index=1"
      sha256 "d38c9ae06c387da151492dd5862c58551559dd6d2b1877c74cc1e11754221fe4"
    end
  end

  on_linux do
    depends_on "readline"

    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  def install
    # Temporary work around for patches. Remove in the next release.
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    args = %w[--disable-silent-rules --disable-asciidoc]

    if OS.mac?
      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-libmount" # does not build on macOS
      args << "--enable-libuuid" # conflicts with ossp-uuid
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
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
