class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/testssl/testssl.sh/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "7beafef432baecf76ef76f2ae022b5ada4ea7fad54e02ae7d192db85b42a496f"
  license "GPL-2.0-only"
  head "https://github.com/testssl/testssl.sh.git", branch: "3.3dev"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "941c4d422ac32d5236eb0a40d6e4c8820162b7c3b539f010d82d32db4271c8be"
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
