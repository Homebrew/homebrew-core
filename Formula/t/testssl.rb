class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/testssl/testssl.sh/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "1c4bb10185a67592164eb870c717b8bdd03f290c8d68f9a8c658335ff5ac8b91"
  license "GPL-2.0-only"
  head "https://github.com/testssl/testssl.sh.git", branch: "3.3dev"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "9e385c68f0225f517f2aac0a60f28a3caa6516c726e228e28dac60e5d1b0d1e9"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "bind" => :test # can also use `drill` or `ldns`
    depends_on "util-linux" # for `hexdump`
  end

  def install
    bin.install "testssl.sh"
    man1.install "doc/testssl.1"
    prefix.install "etc"
    env = {
      PATH:                "#{Formula["openssl@4"].opt_bin}:$PATH",
      TESTSSL_INSTALL_DIR: prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"testssl.sh", "--local", "--warnings", "off"
  end
end
