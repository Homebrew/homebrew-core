require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.6.1.tgz"
  sha256 "5d6600d3aaa08f4fe95d7cb30f25df2cc6c116fca8579ba7b637baf7e8474e83"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5c330bf94192830c9d3e60c536d49f59bae3300d1fc8533b8e9b9681aaa1a89" => :sierra
    sha256 "72aa361ccd592df5505ac90b7c0ea7ee04fb4762ba4d381369ee493e61d7b756" => :el_capitan
    sha256 "ec62ca6f928e292eb944e3618c81aa7b17d124bc34dde9133204206438652fe2" => :yosemite
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
