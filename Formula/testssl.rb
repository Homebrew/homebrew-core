class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.9.5-7.tar.gz"
  version "2.9.5-7"
  sha256 "cefa572026119fbc872d24dc0fcec64a105b0e11a85291b48f0e5ef494f55517"
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
