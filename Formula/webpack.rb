require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.4.0.tgz"
  sha256 "ca00c3b8860bb582c5e1c3e96ae0010be5ba36db00b7e6eea9fbffb65d07240c"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "3b1e5fed22d42c80ca93bde4b192fc7d2b1d9a7fd3fa0d71e67cf0d2a340a3a0" => :sierra
    sha256 "4d40c6888673ef0c4dd18c09e2e5a89902478f76b1e8c8e0fe5871a4049fbda9" => :el_capitan
    sha256 "4dc38ab74eed800d0ba937fc87429cde87f3b4a4a084d17b48498ac1b31dc71b" => :yosemite
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
