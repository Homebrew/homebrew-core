class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/3.0.4.tar.gz"
  sha256 "92d17b8139c50d7dc865942fdf35fc0375cd7a98af655fba1de479cfa4fd8e44"
  license "GPL-2.0"
  head "https://github.com/drwetter/testssl.sh.git", branch: "3.1dev"

  bottle :unneeded

  depends_on "openssl@1.1"

  def install
    bin.install "testssl.sh"
    man1.install "doc/testssl.1"
    prefix.install "etc"
    env = {
      PATH:                "#{Formula["openssl@1.1"].opt_bin}:$PATH",
      TESTSSL_INSTALL_DIR: prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system "#{bin}/testssl.sh", "--local", "--warnings", "off"
  end
end
