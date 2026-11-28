class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/testssl/testssl.sh/archive/refs/tags/v3.2.5.tar.gz"
  sha256 "23bb53d50ae093b89631e9fff547c087f632bf35f7a3d7dc78dd4ffff56cd779"
  license "GPL-2.0-only"
  head "https://github.com/testssl/testssl.sh.git", branch: "3.3dev"

  bottle do
    manifest_sha256 "9a07da5784941d5e6d46128caefcb087795e0050086bf9e8baf73783668b6f2b"
    sha256 cellar: :any_skip_relocation, all: "160c21907a8cf6415c74f2ecc97b4315825a71445fff4a167a880e5a74988217"
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
    openssl_bin = dep("openssl").opt_bin
    env = {
      PATH:                "#{openssl_bin}:$PATH",
      TESTSSL_INSTALL_DIR: prefix,
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"testssl.sh", "--local", "--warnings", "off"
  end
end
