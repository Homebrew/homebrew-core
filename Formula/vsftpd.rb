class Vsftpd < Formula
  desc "Secure FTP server for UNIX"
  homepage "https://security.appspot.com/vsftpd.html"
  url "https://security.appspot.com/downloads/vsftpd-3.0.4.tar.gz"
  mirror "https://fossies.org/linux/misc/vsftpd-3.0.4.tar.gz"
  sha256 "6b9421bd27e8a6cdeed5b31154f294a20b003a11a26c09500715a0a6b1b86a26"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?vsftpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "a72e5769f4b38407207ffad9d8c62eddf87c97fe31545b1725c67e45cfee9a51"
    sha256 big_sur:       "337d1f3d213f9ce424bc2b714f4f4279a0cfb6ff9c7f17837f4ba14a346f8896"
    sha256 catalina:      "d34baa041fa451af6d2e1f065259a1f2333d666506b8ee75edbaf4ce585a4152"
    sha256 mojave:        "477a576822bccca0faac9c8fa2483bfb2b3be704c89680cd6fc563198725f79a"
    sha256 x86_64_linux:  "183b1d0636592778feac38382af55560cb4013f7d1743f798479329d5f247b29"
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
