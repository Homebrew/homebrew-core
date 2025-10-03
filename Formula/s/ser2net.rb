class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.5.tar.gz"
  sha256 "96dfc3fd06b1bf4d7c1f46d7e8cc1eff555de64f419d76f57bd0346e000f9781"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_tahoe:   "b3a9ce35452297c1f503474f1e7836cd8f2fe6fa5ab00972bde8fd0410095af1"
    sha256               arm64_sequoia: "406e3255e7945d3fd302aecbc4660feac2b4bd16521ca1e861c01fd8faf078ff"
    sha256               arm64_sonoma:  "a132540ee75e1bf2f91680574936ef142af9cfed8ae125b33184826ed7013afe"
    sha256 cellar: :any, sonoma:        "6fb76370199f728ee945e89f3efb26ffb7c8c6ea4eba3db8341162832096fbda"
    sha256               arm64_linux:   "50a7347bef5d23ee70c69449d5be2037191e31d88233c8276449aea05583d43b"
    sha256               x86_64_linux:  "aa68040612fde0237813596558ee9c5d5a94ad5be4cdb5a0b820905931d7d39c"
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
