class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.9.5-5.tar.gz"
  version "2.9.5-5"
  sha256 "836a7b45455c95f17c4d7eec9468028a7fc6b613fd4b3c8e8e125b7b8206b89d"
  head "https://github.com/drwetter/testssl.sh.git", :branch => "2.9dev"

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
