require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.13.tgz"
  sha256 "ecb960c336b95b38dd15cf4f938c6c130566061c32a5c8e0d199a351dd0709f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5bcbf8dbddf1adc97ef6063179b2a0761e8271a204426b045c2f5f50d7b238c" => :catalina
    sha256 "0333ca88836805f95f5576db15943f10297587f97703c065eae692b877ad281f" => :mojave
    sha256 "d980526d18bd0f0b5cd066aa69651174a05adcb94069ea95d60c46fe1b3de592" => :high_sierra
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
