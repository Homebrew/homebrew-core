require "language/node"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https://github.com/seamapi/seam-cli"
  url "https://github.com/seamapi/seam-cli/archive/refs/tags/0.0.33.tar.gz"
  sha256 "5a496af613cf30dfa8a0a31bb67be7164321980dde9b4ff1575ae28deac77a56"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    bin.install "bin/seam.cjs" => "seam"
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/seam --version")
  end
end
