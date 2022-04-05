require "language/node"

class TopPost < Formula
  desc "⚙️ Show Hacker News articles in the terminal"
  homepage "https://github.com/daschaa/top-post"
  url "https://registry.npmjs.org/top-post/-/top-post-0.0.9.tgz"
  sha256 "cb2f030eed227c026a49864888ccec84c5ad124333294563bbe5050b1c0326cf"
  license "MIT"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = `#{bin}/top-post --help`
    puts output
  end
end