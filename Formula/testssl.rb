class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/3.0.2.tar.gz"
  sha256 "cfca31a0e5fd0e706002e7c1b044c11be5140091f0e22f0ae5b9aa644ef50da2"
  head "https://github.com/drwetter/testssl.sh.git", :branch => "3.1dev"

  bottle :unneeded

  depends_on "openssl@1.1"

  def install
    bin.install "testssl.sh"
    man1.install "doc/testssl.1"
    prefix.install "etc"
    env = {
      :PATH                => "#{Formula["openssl@1.1"].opt_bin}:$PATH",
      :TESTSSL_INSTALL_DIR => prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system "#{bin}/testssl.sh", "--local", "--warnings", "off"
  end
end
