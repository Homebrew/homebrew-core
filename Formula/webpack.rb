require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.11.0.tgz"
  sha256 "4a5850909939fee6ef646388a8cdedec75ed34b58dc662ca3c01c6568d1dc1ba"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "0b8323f032735a2f50b19df426fd21b670255259639168b0b7de8dd8b1596352" => :high_sierra
    sha256 "5232e26737aa3213bc4802ad40c7af17ac2bffbdaebcbe611f23888956fa3d8a" => :sierra
    sha256 "9de30d9cc35289e4afc4a3c7225792b30b395aa843bf9cec701aba3015c27039" => :el_capitan
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
