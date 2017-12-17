require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.10.0.tgz"
  sha256 "8c48dd80c28bd3e7e31114771f944ae42478ff87931be1a686f85d4f61149db7"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "5ecd06f7039b96ec10790573134a3012e48fea1add8c42c529e16e7da53ca9ce" => :high_sierra
    sha256 "5623a41963b634f1e920e7373f4bc9bb8bfbbe424531f1d984e36f819ce6de7e" => :sierra
    sha256 "28105908fc8c3d2a0186bf187374e130aa1ed1da54f1dc0926319c736a1856fb" => :el_capitan
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
