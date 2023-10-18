class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.2.tar.xz"
  sha256 "87abdfaa8e490f8be6dde976f7c80b9b5ff9f301e1b67e3899e1f05a59a1531f"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]

  # The directory listing where the `stable` archive is found uses major/minor
  # version directories, where it's necessary to check inside a directory to
  # find the full version. The newest directory can contain unstable versions,
  # so it could require more than two requests to identify the newest stable
  # version. With this in mind, we simply check the Git tags as a best effort.
  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a40499918175d7917ebc46d32cf6bfa9ab7f0cffc1190d0505dd8de69be1e1e7"
    sha256 arm64_ventura:  "7f404730ebcdb1d661efc780d220f25dfef1ae595991809987397e57b223c82b"
    sha256 arm64_monterey: "6ef2a1dca2a120bb981f10c99324fc9d6dbe5a423e8c2070a166d0e1eeb77709"
    sha256 arm64_big_sur:  "672d4028bd8523cd01bb4ef71b235683e3880d698b3ce9b33c2de60f6ec9f9e5"
    sha256 sonoma:         "b5305a847a723bdfd55d3937a86e865ea62e3360ccbfc05fcedb89c128c16b42"
    sha256 ventura:        "f1bd7e4fc3e806211d72a5ea07bbf4ed53bbd7cf07c3499de7ab17ea32137f98"
    sha256 monterey:       "568f6e7c70c468c3d2e12cbde331ea8820f0e1e0cc5892587d8a88ff08f4db35"
    sha256 big_sur:        "42948dc1d845e1e3e60f7f58194b114efb9f09775053349f1eb4de4e01902473"
    sha256 x86_64_linux:   "4a7afa9a7913aaf22e5611c74fe313b51829b8c58161aa0578b8b7c11edc794e"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "readline"

    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "flock", because: "both install `flock` binaries"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  def install
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
