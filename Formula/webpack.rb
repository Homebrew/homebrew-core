require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.11.0.tgz"
  sha256 "4a5850909939fee6ef646388a8cdedec75ed34b58dc662ca3c01c6568d1dc1ba"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "4a959a8204df945850f4cd6713edff47ddcc89c36e3cb4204c4492f1e563e9b8" => :high_sierra
    sha256 "0348618ee6c81fb9e096198ef6e9e898b5c43fe6bcd563f376bb8ff468f2a539" => :sierra
    sha256 "12f3de3c3cab637647c9ea67b107590eb9f145f67bff4586f23e7f240413abf9" => :el_capitan
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
