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
    sha256 arm64_big_sur: "39c9723d0b2bdb7514c497c5ca38a8c5925e0586d2391fcab7ff3b52be0ea702"
    sha256 big_sur:       "aca3609846714ed749df94668ae6e90b28d762c4a18066089af03310de6a8ab5"
    sha256 catalina:      "21e36b15fcc37ae27c2e756e029714ef573a74c544d5f691a8bfe7e327143d01"
    sha256 mojave:        "5ffca9c3643cb55a9fcdc53b5d6b044bbe9303c13fb20f7e7b46896f5db85b34"
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

  plist_options startup: true, manual: "sudo vsftpd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/vsftpd</string>
          <string>#{etc}/vsftpd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/vsftpd -v 0>&1")
  end
end
