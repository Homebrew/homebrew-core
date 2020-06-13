require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.10.tgz"
  sha256 "787a4c1d644ad622b3185f1e20843990c7325e577a5cf34b6db846a8273c6a4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "57261bf045c090bf41026d2d8606feb6ef210e3e777b8d92c550e9c9f0f5ba09" => :catalina
    sha256 "c3a782d5a4809e995491e1106dfb9f59ca92a4db24e0a4fe6e2ab191bb197d7c" => :mojave
    sha256 "21fdf0801a14aa143cecf97a7b1065f1d0edfdc7fe403eb03abc32ec7d878cd5" => :high_sierra
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
