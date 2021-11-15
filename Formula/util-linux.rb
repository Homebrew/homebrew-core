class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.2.tar.xz"
  sha256 "6a0764c1aae7fb607ef8a6dd2c0f6c47d5e5fd27aa08820abaad9ec14e28e9d9"
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
    sha256 arm64_monterey: "d70957ab44697dfc2e2c734b9c3f33ae71d656a04c0489d4c56e8f4f34b3f675"
    sha256 arm64_big_sur:  "e190bf958aa8232a6a344f75c726457eaf7885144dd650e071b80d480dcdb2d2"
    sha256 monterey:       "053af101a65713dcd7f7419ac06283bd605e4a2464048f8cc60844d5169a92d7"
    sha256 big_sur:        "78816a7ee9d0a448fb83803f95a9e495f2c99d29a697a3419043666fa6d27bce"
    sha256 catalina:       "82f2fb926262ca95243325d61e53bcd06d6751f9606f5737cb6d7c45d6db77a5"
    sha256 x86_64_linux:   "6428a98784f5d7b36144907dd4e4a5b767be347fa43533f2af196846e3c08cd3"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "asciidoctor" => :build
  depends_on "gettext"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  # Change mkswap.c include order to avoid "c.h" including macOS system <uuid.h> via <grp.h>.
  # The missing definitions in uuid.h cause error: use of undeclared identifier 'UUID_STR_LEN'.
  # Issue ref: https://github.com/karelzak/util-linux/issues/1432
  patch :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = std_configure_args + %w[
      --disable-silent-rules
    ]

    if OS.mac?
      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-libmount" # does not build on macOS
      args << "--enable-libuuid" # conflicts with ossp-uuid

      # To build `hardlink`, we need to prevent configure from detecting macOS system
      # <sys/xattr.h>, which doesn't have all expected functions like `lgetxattr`.
      # Issue ref: https://github.com/karelzak/util-linux/issues/1432
      inreplace "configure", %r{^\tsys/xattr.h \\\n}, ""
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

    system "./configure", *args
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

__END__
diff --git a/disk-utils/mkswap.c b/disk-utils/mkswap.c
index c45a3a317..0040198c8 100644
--- a/disk-utils/mkswap.c
+++ b/disk-utils/mkswap.c
@@ -30,6 +30,10 @@
 # include <linux/fiemap.h>
 #endif
 
+#ifdef HAVE_LIBUUID
+# include <uuid.h>
+#endif
+
 #include "linux_version.h"
 #include "swapheader.h"
 #include "strutils.h"
@@ -42,10 +46,6 @@
 #include "closestream.h"
 #include "ismounted.h"
 
-#ifdef HAVE_LIBUUID
-# include <uuid.h>
-#endif
-
 #ifdef HAVE_LIBBLKID
 # include <blkid.h>
 #endif
