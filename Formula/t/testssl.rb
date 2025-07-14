class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/testssl/testssl.sh/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "b10fcd6fc25ba3832858ac529bfe391d701b68f12b631482a19be98a9efb176e"
  license "GPL-2.0-only"
  head "https://github.com/testssl/testssl.sh.git", branch: "3.2"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b4fe21825f9fdac284931109a0f0bc57b7187e6946115357cad507a86067290"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "bind" => :test # can also use `drill` or `ldns`
    depends_on "util-linux" # for `hexdump`
  end

  def install
    bin.install "testssl.sh"
    man1.install "doc/testssl.1"
    prefix.install "etc"
    env = {
      PATH:                "#{Formula["openssl@3"].opt_bin}:$PATH",
      TESTSSL_INSTALL_DIR: prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"testssl.sh", "--local", "--warnings", "off"
  end
end
