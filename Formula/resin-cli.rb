require "language/node"

class ResinCli < Formula
  desc "The official resin.io CLI tool"
  homepage "https://docs.resin.io/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/resin-cli/-/resin-cli-8.0.2.tgz"
  sha256 "4e1696d6b7f7724672ca11ee6d3d38d583869cc1ea3718fd1694bebc8d62aa3a"

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
