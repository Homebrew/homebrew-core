class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.9.5-1.tar.gz"
  version "2.9.5-1"
  sha256 "505ba9400e1a49759ba84d0cf6ae79f3787f111c64a319094de69635b786c72a"
  revision 1
  head "https://github.com/drwetter/testssl.sh.git"

  bottle :unneeded

  depends_on "openssl"

  def install
    bin.install "testssl.sh"
    man1.install "doc/testssl.1"
    prefix.install "etc"
    env = {
      :PATH => "#{Formula["openssl"].opt_bin}:$PATH",
      :TESTSSL_INSTALL_DIR => prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system "#{bin}/testssl.sh", "--local", "--warnings", "off"
  end
end
