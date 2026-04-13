class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.2.tgz"
  sha256 "3d5673a478dbd04e7fa5bbf25f90f34e2f9b1f74442d704fd8f24f975c825cf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16476072fa803d9b3170cef36f945cd88f206357b3921d9803bad691e7d24230"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
