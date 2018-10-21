require "language/node"

class ResinCli < Formula
  desc "The official resin.io CLI tool"
  homepage "https://docs.resin.io/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/resin-cli/-/resin-cli-8.0.2.tgz"
  sha256 "4e1696d6b7f7724672ca11ee6d3d38d583869cc1ea3718fd1694bebc8d62aa3a"

  bottle do
    sha256 "1e11dca0cab1b9760c80c23f160477df9fe3b86b75928fd4d4d33d03dabdadf8" => :mojave
    sha256 "b92c9b701edf03e4ea22b525c41c972b1c8f3d8ab077bc9c2b6b22e317e992de" => :high_sierra
    sha256 "71801af30f21f8d4bd6b2e8fb1b4508aca379080a7126a8359bbdfa8b79495a8" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/resin login --credentials --email johndoe@gmail.com --password secret", 1)
    assert_match "Logging in to resin.io", output
  end
end
