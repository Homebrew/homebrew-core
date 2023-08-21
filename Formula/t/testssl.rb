class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v3.0.8.tar.gz"
  sha256 "22c5dc6dfc7500db94b6f8a48775f72b5149d0a372b8552ed7666016ee79edf0"
  license "GPL-2.0-only"
  head "https://github.com/drwetter/testssl.sh.git", branch: "3.1dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a76af565cfb3d79ede861d1ef2edaa3bea39f94dcfa3d8bd7ee72979afbb4f5"
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
    system "#{bin}/testssl.sh", "--local", "--warnings", "off"
  end
end
