class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v3.0.6.tar.gz"
  sha256 "05768444d6cf3dc5812f8fb88695d17a82668089deddd6aaf969041ba4c10b10"
  license "GPL-2.0-or-later"
  head "https://github.com/drwetter/testssl.sh.git", branch: "3.1dev"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "720715f209d47df4a0e54532a3d181e1294384855e709481e471244be517ea52"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "bind" => :test # can also use `drill` or `ldns`
    depends_on "util-linux" # for `hexdump`
  end

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
