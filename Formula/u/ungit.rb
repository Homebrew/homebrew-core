require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.24.tgz"
  sha256 "76052297abb515acc334cf27a289e7ea983ba755641f293bb711d086deb9c031"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4aa6256557fa2fb16456857d173847f1e7578a775499fc9afaa82c25f4a7d6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a3c7e14b137d28f0852a7400f3d16fe78b85eda19cccff5f2786671e71af33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a3c7e14b137d28f0852a7400f3d16fe78b85eda19cccff5f2786671e71af33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a3c7e14b137d28f0852a7400f3d16fe78b85eda19cccff5f2786671e71af33"
    sha256 cellar: :any_skip_relocation, sonoma:         "7137b03e28ef975a6b58d44d618dfbc40610d919bddc6d6ec5c0cb891736787a"
    sha256 cellar: :any_skip_relocation, ventura:        "3d4156aefbab25d304c88411fa58145ac950ec70b6e73b7244f16112371029f6"
    sha256 cellar: :any_skip_relocation, monterey:       "3d4156aefbab25d304c88411fa58145ac950ec70b6e73b7244f16112371029f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d4156aefbab25d304c88411fa58145ac950ec70b6e73b7244f16112371029f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a3c7e14b137d28f0852a7400f3d16fe78b85eda19cccff5f2786671e71af33"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 8

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
