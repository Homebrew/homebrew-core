class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/3.0.5.tar.gz"
  sha256 "9de744fe0e51a03d42fa85e4b83340948baeaa7080427f90b0efd23e9106fece"
  license "GPL-2.0"
  head "https://github.com/drwetter/testssl.sh.git", branch: "3.1dev"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "720715f209d47df4a0e54532a3d181e1294384855e709481e471244be517ea52"
  end

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
