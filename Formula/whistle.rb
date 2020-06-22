require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.11.tgz"
  sha256 "a974bfbe24496c4da84f9e307e97274d0944d9ee9505e74cebef1d21c0f7835f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fd3aebbc900a0fbc2868cee23ee86dc5875fc58db99d07890510173e47c972e" => :catalina
    sha256 "413a0c28bfccb8339bb56807ee4e9bc3647163c7e99cf4b47fc62eb286a46deb" => :mojave
    sha256 "6dcf7fc0a027b173f62dfb0a622ca203a7fba74d4f6b80ddbf50c6d4695c0f59" => :high_sierra
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
