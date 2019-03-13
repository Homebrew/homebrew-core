require "language/node"
class Tianqi < Formula
  desc "A weather tool in your command line."
  homepage "https://github.com/smallyard/tianqi"
  url "https://github.com/smallyard/tianqi/archive/v1.5.3.tar.gz"
  sha256 "888112d589026d2e448131b8f69ef725592d2f1c4148bbc0df806a608a3ce67f"

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/tianqi"]
  end

  test do
    assert_match "天气", shell_output("#{bin}/tianqi")
  end
end
