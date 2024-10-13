class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.6.2.tar.gz"
  sha256 "63bafcd65bb9270a93b7d5cdde58ccf4d279603ff6d044ac4b484a257cda82ce"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "f3a48bb90a74bc4a7523165733ec373bde6dca179f82072484590b7626e41d9a"
    sha256 arm64_sonoma:   "8b7b88a0bbbf4325b6f47ece8462d1750a624430d22cf86dd1ce04dc3c403fed"
    sha256 arm64_ventura:  "6cb048373bba9403792c7516530d82f16f55546f4ffd28834552f3cc3863a8e8"
    sha256 arm64_monterey: "84daf687cbd1d5a3868eacb728e89c836ed61c53317d72e66d87ed5f41926e40"
    sha256 sonoma:         "9c80d4349d5cf1cf5468868dd002368e9e056e62e09c29e1554dd152ef561704"
    sha256 ventura:        "d263b99458dc09221aa815d54ad59ce0515f73ff509814e858994f126a99930f"
    sha256 monterey:       "37ebafecddf088adca232725b8ee53f43b42ce7a44599b25b8e7d921f1bcb397"
    sha256 x86_64_linux:   "63c7c475b026aa201173d79bafbe0b50522e902da600c22466fa7f97aed52394"
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
