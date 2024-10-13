class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.2.tar.xz"
  sha256 "d78b37a66f5922d70edf3bdfb01a6b33d34ed3c3cafd6628203b2a2b67c8e8b3"
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
    rebuild 1
    sha256 arm64_sequoia:  "8b634a2c63b8d971fcba7ecf937cfc45a2fe9263b5ce6f01ef1704f58c28547e"
    sha256 arm64_sonoma:   "ae2f7c6c2a844f8cbd3522f85e51cb929d03a8c9eed9a66d14a81b2632f9dcb4"
    sha256 arm64_ventura:  "b933894463178a94495ced95268b2d66ccdc0c9e2e408b7fdc4b5a36016f228a"
    sha256 arm64_monterey: "4b0c25db0dcd8f13e1d881b7ecf5eb80ebd53453b56fd0c096a2745b97c90d42"
    sha256 sonoma:         "ad20c2beac16f7d241569f93d0edd5b19f0bb2fafd62c227747ea20d9f615892"
    sha256 ventura:        "0b62fc43806131f0b9f96916b0887ad85ae47db2418386721fc3da6d3f49dec7"
    sha256 monterey:       "1fed3dce8f5487a95fab00de380f3ff3320a43b94ad9949a102466bb6fbc3bbd"
    sha256 x86_64_linux:   "773c91eea7c86a3a5a18ae1b43a43c9346b190ccf7640bb811e4cadb77a42874"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "pkg-config" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "readline"

    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "flock", because: "both install `flock` binaries"
    conflicts_with "ossp-uuid", because: "both install `uuid.3` file"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  # uuid_time function compatibility fix on macos
  # upstream patch PR, https://github.com/util-linux/util-linux/pull/3013
  patch do
    url "https://github.com/util-linux/util-linux/commit/9445f477cfcfb3615ffde8f93b1b98c809ee4eca.patch?full_index=1"
    sha256 "7a7fe4d32806e59f90ca0eb33a9b4eb306e59c9c148493cd6a57f0dea3eafc64"
  end

  def install
    args = %w[--disable-silent-rules --disable-asciidoc]

    if OS.mac?
      # Support very old ncurses used on macOS 13 and earlier
      # https://github.com/util-linux/util-linux/issues/2389
      ENV.append_to_cflags "-D_XOPEN_SOURCE_EXTENDED" if MacOS.version <= :ventura

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
      args << "--with-bashcompletiondir=#{bash_completion}"
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
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
