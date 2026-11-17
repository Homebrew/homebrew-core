class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://wproxy.org/"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.15.tgz"
  sha256 "7fd3dbd663e35574c628a7ca346153ab740bdec38c647a1faa44663c6ec0110c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d29c6fb53e58f172797312b447fed4e19e0cd3e395f98be7fa2a3c4cd4e5341"
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
