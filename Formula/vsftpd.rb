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
    rebuild 1
    sha256 arm64_monterey: "40040ca15be416c21fc08f8f5cd19d17c273381b8a5a5aa0cbf7c35940c8a7ea"
    sha256 arm64_big_sur:  "7978d8b0121a19bee82b3b3f923685fd9ea462c35f3a28ab47e8a665116f6ef8"
    sha256 monterey:       "67f3a10c76d5ca48e0e12cc4392e06b63f42c230b186d8a3c3ccd3acf9991b9e"
    sha256 big_sur:        "e0ef6c46feb52bbe5e970d5ddd357f38837ddc69a7cd34a74a8c33cb3ccfb398"
    sha256 catalina:       "b5c7f2c2abd7937bcaccb69160701f46003b5167229a124fa1ea22ff463a04d5"
    sha256 x86_64_linux:   "afab189ea0991cf4d28552707a50fe005d7cb1b18ec249360f0dae7e3db3a17f"
  end

  uses_from_macos "perl" => :build

  # Patch to remove UTMPX dependency, locate macOS's PAM library, and
  # remove incompatible LDFLAGS. (reported to developer via email)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5fbea7b01a521f840f51be6ffec29f612a37eed3/vsftpd/3.0.3.patch"
    sha256 "c158fac428e06e16219e332c3897c3f730586e55d0ef3a670ed3c716e3de5371"
  end

  # Patch to disable all calls to setrlimit, as macOS, starting from
  # Monterey does not support this syscall. (reported to developer via
  # GitHub)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e4dd5d67152bb2541c5e38e8bb834ed5b165fcaa/vsftpd/3.0.5.patch"
    sha256 "95afc3bc00dd6cc37a2c64b19b1e7e30951ec022f839dbab1773b7716966b9cf"
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
