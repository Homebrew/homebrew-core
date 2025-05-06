class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.4.tar.gz"
  sha256 "75864434c4f002fa3570daaffeb6f794354fca6d8b5814b8386977a3b1416be9"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "58992ed17c1674ed4c3966d81e1707066b0eeb6060b00ad2f9a806bac648fae2"
    sha256 arm64_sonoma:  "62fe17948edcd3bcc45390cc376187f226499febb39da2325de79b4f61b853cc"
    sha256 arm64_ventura: "9b44815a69d50a6b90ba151efd9d249c84fe72e79af313c45cbc7024a9d17c69"
    sha256 sonoma:        "b2768bd79fee75dfa6c90e867c0cd310aca45d783dc3670e29c8c6fc44b685ef"
    sha256 ventura:       "29cab0a79d777129131d2deb84463f5d0ef4ed5e8a5d6e713c1ab3ef18e12141"
    sha256 arm64_linux:   "25a61d3a99c2c5886eef9ff5e2d21a60d6901083858215fa22e66fb3e07adf1e"
    sha256 x86_64_linux:  "548cc6d37793cd0028a9e57b86958ef53b0b7283284051adb0dd9448d81e5faf"
  end

  depends_on "gensio"
  depends_on "libyaml"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-n"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
