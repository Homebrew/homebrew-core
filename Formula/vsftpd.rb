class Vsftpd < Formula
  desc "Secure FTP server for UNIX"
  homepage "https://security.appspot.com/vsftpd.html"
  url "https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz"
  mirror "https://fossies.org/linux/misc/vsftpd-3.0.3.tar.gz"
  sha256 "9d4d2bf6e6e2884852ba4e69e157a2cecd68c5a7635d66a3a8cf8d898c955ef7"

  bottle do
    rebuild 2
    sha256 "43b17ac94b152a4922a915b7e2efc89c3da7ee53e00f860136c5c58489e2b782" => :catalina
    sha256 "5605a908ab4b24008e48f2280107695a7afaae8a1a521964b8f2248d2baa960a" => :mojave
    sha256 "dbfc9b28f5ea49dda09d31fb630d995b72fd63b83b358e04156329252c3ab25b" => :high_sierra
    sha256 "22349437bd4d75b1ffd2fddfd90f92367e0a4f478f540b9086457541883f2c3b" => :sierra
    sha256 "108243559f3fea06d140173a3e3cb497c2f22c47d45e85ae108c088c1a1370df" => :el_capitan
    sha256 "25a9d2e92ca7e3efda6c9882a62ad5927c0c5e450eca4d62d7829c467dd086d9" => :yosemite
  end

  # Patch to remove UTMPX dependency, locate macOS's PAM library, and
  # remove incompatible LDFLAGS. (reported to developer via email)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/vsftpd/3.0.3.patch"
    sha256 "7947d91f75cb02b834783382bcd2a2ef41565a76e31a5667a1ea0bd5bef48011"
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

  plist_options :startup => true, :manual => "sudo vsftpd"

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
