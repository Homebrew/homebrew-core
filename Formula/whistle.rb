require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.7.tgz"
  sha256 "cc93aa4e5ff46c80edf7754878e55494f199481b800d2ba19c0e4996358ef633"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89d75d8fd94e6bb272787d1e30da2981dc9820f340dd52d7a40c111a0d5d50dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "06016938110db64a8645a7729d10a0120aa342e06d2414a9ffca4519c60eb4ef"
    sha256 cellar: :any_skip_relocation, catalina:      "b0b7eacff7379d821cfcb338c23b4484c0a1d4bc39aa2d862413a6f6d030ac70"
    sha256 cellar: :any_skip_relocation, mojave:        "7937d9c596a5afb57f45c28b8d0c0d576f9ae1a75a7cd7cb12237919dc793aeb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
