class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.6.tar.gz"
  sha256 "a468073c7bf8166c78c61d30bba487916dc4088e98f96e190b37ea8100a94fd4"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_tahoe:   "17812e80ef8acb52f461d781c9b559a3716b79f0dfdecdc19a683dd89c1f9ab1"
    sha256               arm64_sequoia: "a8bdd311d914d1805852233dd7c901a7a5a6fa134de64c350281e7b07db5bcc1"
    sha256               arm64_sonoma:  "9343b18930404973d54600d4ebb2560dc70a2102857f036a64f9171a536344f4"
    sha256 cellar: :any, sonoma:        "cc2fcf31c85bfe59b6265a7c2e79dc7090ff0f0c35f3ac2eecda9bc87340e958"
    sha256               arm64_linux:   "a1b129a2b9f117a51f66ec05488c973d4a5817286fbc45e4c8fff712b66f5592"
    sha256               x86_64_linux:  "680a6e51a2288d6be62bca3d00a8a9b52b7999718163098722ec624fcf3ce10e"
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
