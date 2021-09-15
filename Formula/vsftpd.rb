class Vsftpd < Formula
  desc "Secure FTP server for UNIX"
  homepage "https://security.appspot.com/vsftpd.html"
  url "https://security.appspot.com/downloads/vsftpd-3.0.5.tar.gz"
  mirror "https://fossies.org/linux/misc/vsftpd-3.0.5.tar.gz"
  sha256 "26b602ae454b0ba6d99ef44a09b6b9e0dfa7f67228106736df1f278c70bc91d3"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?vsftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "11589c537eaaaba8cfd68207f078d8d4d0485b40d8553c23ae7caf76ab5104d7"
    sha256 big_sur:       "1ede9475ee1dc93ad54a413ca82bdd15d3b0f50b9d6f731cf7e3578cae8b0cbd"
    sha256 catalina:      "79b378cfa6134e01ff2d253578c24601e5bb2d2514e7427da083a9af0446ac14"
    sha256 mojave:        "d6ebf6f6f786c417698436901442203446bc6c64a9d50e6134b4035e2c0c5002"
    sha256 x86_64_linux:  "124a191424c1d2f2261a858bc2d2a8319dc91572035f62c9f7065c08cdfd6e5b"
  end

  uses_from_macos "perl" => :build

  # Patch to remove UTMPX dependency, locate macOS's PAM library, and
  # remove incompatible LDFLAGS. (reported to developer via email)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5fbea7b01a521f840f51be6ffec29f612a37eed3/vsftpd/3.0.3.patch"
    sha256 "c158fac428e06e16219e332c3897c3f730586e55d0ef3a670ed3c716e3de5371"
  end

  def install
    inreplace "defs.h", "/etc/vsftpd.conf", "#{etc}/vsftpd.conf"
    inreplace "tunables.c", "/etc", etc
    inreplace "tunables.c", "/var", var
    system "make"

    # make install has all the paths hardcoded; this is easier:
    sbin.install "vsftpd"
    etc.install "vsftpd.conf"
    man5.install "vsftpd.conf.5"
    man8.install "vsftpd.8"
  end

  def caveats
    <<~EOS
      To use chroot, vsftpd requires root privileges, so you will need to run
      `sudo vsftpd`.
      You should be certain that you trust any software you grant root privileges.

      The vsftpd.conf file must be owned by root or vsftpd will refuse to start:
        sudo chown root #{HOMEBREW_PREFIX}/etc/vsftpd.conf
    EOS
  end

  plist_options startup: true
  service do
    run [opt_sbin/"vsftpd", etc/"vsftpd.conf"]
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/vsftpd -v 0>&1")
  end
end
