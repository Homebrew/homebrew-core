class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.9.5-8.tar.gz"
  version "2.9.5-8"
  sha256 "b236094a5360883bc8b1bb283c8a2c6f75230ca42e88bc04f0ab65074cd21e8a"
  head "https://github.com/drwetter/testssl.sh.git", :branch => "2.9dev"

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
