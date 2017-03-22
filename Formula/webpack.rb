require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.3.0.tgz"
  sha256 "f0ad645072951231e7f29aa22f264c5f9d6499b43ca4b02e5afdaa68ad7b5545"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9480d36adc38412a516736c41fed567b25530cb0b392ac4b5be71a9faab2f54" => :sierra
    sha256 "319dc6effeb83376608d3d50bea4501c597459def19a21695d41bcfbf42790fd" => :el_capitan
    sha256 "1c6d5d1850220bb1d81037c16421cadcc37e65443a02ef2e7808a7cbb70cea3c" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"index.js").write <<-EOS.undent
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "bundle.js"
    assert File.exist?("bundle.js"), "bundle.js was not generated"
  end
end
