class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.5.tar.gz"
  sha256 "96dfc3fd06b1bf4d7c1f46d7e8cc1eff555de64f419d76f57bd0346e000f9781"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "cbe1f1387efd453876ec550e71be6b964141e4787f4b0e9bc19a34f8477feaf5"
    sha256 arm64_sonoma:  "58304b63df73f5fbd2e02cf18ab406de8ba1611ddabfcd0620a748856534e5e5"
    sha256 arm64_ventura: "0b1642f10197da573c236e60918ea46d0152c8dc00d4fdaf13eabd11e8e80dfd"
    sha256 sonoma:        "72b6d445847b1d581db343df599bb582d4565507e31ef27d0a75b9bc7f68a279"
    sha256 ventura:       "09673ca2ff144cb80eed872d133e04358b534f5de6354dd87c7744ed0ab0592e"
    sha256 arm64_linux:   "00d13a3c5d6b7512d27fbec2f4bf6e94f0f0efd58ab2cc8aff1e0720ba8ecdcf"
    sha256 x86_64_linux:  "0000d869c4a1bdafbfe8b8b65d4c3f05c0e77629e33cb295d31e303774dce347"
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
