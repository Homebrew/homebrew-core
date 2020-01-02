class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/3.0rc6.tar.gz"
  version "3.0rc6"
  sha256 "fc5aee354e5350448ac48294dee04c34989a21517d2181ff83738b6858eb12f2"
  head "https://github.com/drwetter/testssl.sh.git", :branch => "3.0"

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
