require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.7.1.tgz"
  sha256 "1e135fc189ede52004d4c8d28e9866257d7c8fde1657b54733fd1c20ffe6ca2a"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "aab55cf92fbef20e21cfbec4979eba43bf9d857315718eb0a8cfa0a77db771ad" => :high_sierra
    sha256 "858227c078cdf26403d6bd3a5ad0ef16ae117feacb0b5d86153e346935edcc72" => :sierra
    sha256 "c82a8a4eabfb3d80cd30016934fdf5b0a2759e78c5a5c184d72bcea31ff95a7d" => :el_capitan
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
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
