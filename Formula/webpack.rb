require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.1.0.tgz"
  sha256 "bef335e16871db2ac74abbdcc439be423da9aa0f8d497aea52e63d836b34afae"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "f9441bdad36c9260d38c6f2f100512d69223e18a5ca904774bbf48ec245f1b18" => :sierra
    sha256 "01eae5c7ef197c4fb27474bda3da1125d79f0861361e40d362b02ee19e1a215a" => :el_capitan
    sha256 "f8a30e2b80bd3122b8769a2e1a931688c6ea618f54fb6f137a58cb7d5b5b47dd" => :yosemite
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
