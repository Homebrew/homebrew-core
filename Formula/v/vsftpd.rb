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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "01dbfae43456eddf9dda1082d584faffbc1375610626a5b2c6229ae3fdbd13f2"
    sha256 arm64_sequoia: "d878a9c0483cf81228a5301cf5768e613271d731fbf2affa778a475bcea57a09"
    sha256 arm64_sonoma:  "7547e5fa4936a51a84b4e016545b8088199e1f92fc7299f8619b6b3f5b7ba5bf"
    sha256 arm64_ventura: "7e015b54e1995a19395d9802116f3f7d0895818260c1aeddd793ca2b2da806aa"
    sha256 sonoma:        "63fafab3ad2cc9aa1c22643d6b923292a58b0872abbc774fb028b0d79f3febe6"
    sha256 ventura:       "ac39611af47fe2cb0fa24462a75d835016c9edca1a5904ee112886e223fcc0b8"
    sha256 arm64_linux:   "a7e48ecdd12b194050395cc3532a82bcc3724a4d19d0f5e43cb0cc62723f3440"
    sha256 x86_64_linux:  "4443fcbe19aa4dd49e55a9c5fcd7e3c069a07320a4c86b9d252c4020ba7614ee"
  end

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "libcap"
    depends_on "linux-pam"
  end

  # Patch to remove UTMPX dependency, locate macOS's PAM library, and
  # remove incompatible LDFLAGS. (reported to developer via email)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/vsftpd/3.0.3.patch"
    sha256 "c158fac428e06e16219e332c3897c3f730586e55d0ef3a670ed3c716e3de5371"
  end

  # Patch to disable all calls to setrlimit, as macOS, starting from
  # Monterey does not support this syscall. (reported to developer via
  # GitHub)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/vsftpd/3.0.5.patch"
    sha256 "95afc3bc00dd6cc37a2c64b19b1e7e30951ec022f839dbab1773b7716966b9cf"
  end

  def install
    inreplace "defs.h", "/etc/vsftpd.conf", "#{etc}/vsftpd.conf"
    inreplace "tunables.c", "/etc", etc
    inreplace "tunables.c", "/var", var

    args = OS.linux? ? ["LIBS=-lcap -lpam"] : []
    system "make", *args

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

  service do
    run [opt_sbin/"vsftpd", etc/"vsftpd.conf"]
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/vsftpd -v 0>&1")
  end
end
