class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.3.tar.gz"
  sha256 "9c23a3d82c3d36507cdb58e8a0eb33487b600fa491c05f7dcf1aaf8b70566051"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "a272fda6c607417df64f7765877c6b8aa604c96d4cd946cc026cfa3dbc28933b"
    sha256 arm64_sonoma:  "a92a8ab156e9d81b168518b80a25c1a6f45de14ae39c30923a29f4b944366cf5"
    sha256 arm64_ventura: "a5f77fac818178eea2c0a2734d51e20074d83bf693f7293b3db03a70b01578ff"
    sha256 sonoma:        "0d16ac288dab67a5189ee646fcd094bbe0c4e53a2a816670ed34765b45c17cc4"
    sha256 ventura:       "5d1ec48dd8a6cf5fa8ca3d86e1d4e6b93d9c98b988ebb30937081ed22a5cf144"
    sha256 x86_64_linux:  "6f8f3277ad764051be38bd13bbb759f95f94fb514f100335f2152d05b61d4bd9"
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
