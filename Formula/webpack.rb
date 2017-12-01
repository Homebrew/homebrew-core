require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.9.1.tgz"
  sha256 "a6e9567e74564eedbaf2c19a989d1281a6dd7f27c00fe82fb4725712951333cf"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "abff107316f42119c9e418d7746b68656eada927217a1a6fa7e76e26338856a8" => :high_sierra
    sha256 "e849c8246a2b894f347abd1790cfef17aadefd2ecfd28c748239e11dbbdb8578" => :sierra
    sha256 "95cbfb578e123e75ea82f25a80062b79927aa6b1835a39d6a1f162e10b59f620" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
