class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.1.tar.xz"
  sha256 "be9ad9a276f4305ab7dd2f5225c8be1ff54352f565ff4dede9628c1aaa7dec57"
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
    sha256 arm64_sequoia: "535204861eba897448b6c28b54d10276c7f9b71b7a327ed4fd4212c6992617ce"
    sha256 arm64_sonoma:  "9c311e7df48c432995f0b3991512b0175cf13ce4c91ad635f13e5d5818ec5773"
    sha256 arm64_ventura: "6d31dd7ee88f4517f55cfbe4cf175fc9da7aa2c9740d862428ead9aa48139e6e"
    sha256 sonoma:        "bd6d38cd960ba14580f5df59e1ce4086045c99029c488743fcf2083d4e5defa7"
    sha256 ventura:       "cec277c842259f9259d4bc8bb4a982e11d4c1ec88621d4b539d96fcd6886ed67"
    sha256 arm64_linux:   "fa1b4b02f96da7f50c7fe6b22baa322e7ab0c28f42755a216f34286aa06f7897"
    sha256 x86_64_linux:  "62c1095923e34635ab90c5029cac6876ea55e3c8ba089893679038179fbda3c4"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

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

  # bits: only build when cpu_set_t is available. Needed for `--disable-bits`.
  # Remove when included in a stable release; when doing so, also remove
  # `autoconf`, `automake`, `gettext`, `gtk-doc`, and `libtool` build deps and
  # the `autoreconf` call in the `install` method.
  patch do
    url "https://github.com/util-linux/util-linux/commit/45f943a4b36f59814cf5a735e4975f2252afac26.patch?full_index=1"
    sha256 "b372a7578ff397787f37e1aa1c03c8299c9b3e3f7ab8620c4af68c93ab2103b5"
  end

  # fix bash completion, upstream pr ref, https://github.com/util-linux/util-linux/pull/3627
  patch do
    url "https://github.com/util-linux/util-linux/commit/565eb6370c76721bbd0d7fa292d9315a6856f627.patch?full_index=1"
    sha256 "3945234bcfbf4d9126e92b4f808029971ab26330618da53671941ba1a52d8427"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

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
    system "make", "install"
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
