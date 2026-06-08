class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.1.tar.xz"
  sha256 "82e9158eb12a9b0b569d84e1687fed9dd18fe89ccd8ef5ac3427218a7c0d7f7f"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]
  compatibility_version 1

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
    sha256 arm64_tahoe:   "3d9b6c9ed9786e56475bdbf1181d8a59aca9d0dd7bd01ecf782b1d2220033f22"
    sha256 arm64_sequoia: "26073d37214d23bc3da03a92a6250e0b7461c9c3e58b53017bd03958b019f0c0"
    sha256 arm64_sonoma:  "cb76a523dcaa1bfe9b01288c582c83ee165a964978dd6163e4f27a651b7be58f"
    sha256 sonoma:        "9797d1d36e0e2726b41cdc002ed51204b3032a5c69899205790b51bdc2b6d01d"
    sha256 arm64_linux:   "fe7287412da2b1494ac30408eee4e509aa4d137e62b445da9843ce6ce8ca8d55"
    sha256 x86_64_linux:  "700f5145a2588ddc99b51c16504c934e81e34418731e07fba13bfa2949bb6c6e"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "pkgconf" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"

    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "flock", because: "both install `flock` binaries"
    conflicts_with "ossp-uuid", because: "both install `uuid.3` file"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  # Fix macOS builds
  # https://github.com/util-linux/util-linux/pull/4173
  patch do
    url "https://github.com/util-linux/util-linux/commit/d22edc2f100eb8dd83d3515758565cb73b0d2eed.patch?full_index=1"
    sha256 "2fb01154faa3fd8b0fce27eb88049ed9c8f839e706e412399c19c087f7f3b5e1"
  end

  def install
    args = %W[--disable-silent-rules --disable-asciidoc --with-bashcompletiondir=#{bash_completion}]

    if OS.mac?
      # Support very old ncurses used on macOS 13 and earlier
      # https://github.com/util-linux/util-linux/issues/2389
      ENV.append_to_cflags "-D_XOPEN_SOURCE_EXTENDED" if MacOS.version <= :ventura

      args << "--disable-bits" # does not build on macOS
      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-liblastlog2" # does not build on macOS
      args << "--disable-libmount" # does not build on macOS
      args << "--enable-libuuid" # conflicts with ossp-uuid
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
      args << "--without-systemd" # Do not install systemd files
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system "./configure", *args, *std_configure_args

    install_args = []
    install_args << "LDFLAGS=-lm" if OS.linux?
    system "make", "install", *install_args
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
      sum.insert 0, (stat.mode.nobits?(2 ** index) ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end
