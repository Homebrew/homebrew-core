class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "75ecbe4470e74f9ad17f4c4ac733be123b0f67d676ed24cc2b30adb41561e05f"
  license "GPL-2.0-only"
  head "https://github.com/drwetter/testssl.sh.git", branch: "3.2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89c2d9fac34c18ab2661f9b816e137bbb787b9dea9c14993cf7299a9902429fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c2d9fac34c18ab2661f9b816e137bbb787b9dea9c14993cf7299a9902429fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c2d9fac34c18ab2661f9b816e137bbb787b9dea9c14993cf7299a9902429fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "89c2d9fac34c18ab2661f9b816e137bbb787b9dea9c14993cf7299a9902429fa"
    sha256 cellar: :any_skip_relocation, ventura:        "89c2d9fac34c18ab2661f9b816e137bbb787b9dea9c14993cf7299a9902429fa"
    sha256 cellar: :any_skip_relocation, monterey:       "89c2d9fac34c18ab2661f9b816e137bbb787b9dea9c14993cf7299a9902429fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26122e016d5896b307e53cd37cbd0fb040ab684fe5462fca6959efa8a91bbb1f"
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
