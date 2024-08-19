class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.2.tar.gz"
  sha256 "63bafcd65bb9270a93b7d5cdde58ccf4d279603ff6d044ac4b484a257cda82ce"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "9f65fbc6b7dcface5bb5d48a82e945339aa110ca5f0a3ed3b95c8209cad65fd7"
    sha256 arm64_ventura:  "0f1c8705b3b085d9aade4e5c2632487498a9ea15223cfeca1b4e2bfd5bda6011"
    sha256 arm64_monterey: "afeef419f4a6fbf363721e0f5bb77dc02334bb5f50c563ceeed509e69b26fde7"
    sha256 sonoma:         "14b038140ebb72285b7d202246ef41d0f35c74790cc6d69bb4659ccef9e137e1"
    sha256 ventura:        "77d05f05e19103853da14c10600cb01870e4921205479be60ec6677c6b711787"
    sha256 monterey:       "0126e65262c42faced2977e87f9e813ec7ea01c410c0df33f227b78a89d3c97d"
    sha256 x86_64_linux:   "3cf6b299e81f10fbe5add9ad8bcfe8e09a0ee97dc627e14119a7c8c73600d1e9"
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
