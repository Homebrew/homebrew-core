class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.4.3.tgz"
  sha256 "ca6fe44d02d7a8aeabd10cc15f766d8411be5b8aa42e37b50759bf028c75daea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb7f0cb40972249b1bdb69a3b5ea9d028a29452450881c3a951e591400a42374"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
