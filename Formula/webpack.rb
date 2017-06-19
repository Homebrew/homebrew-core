require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.0.0.tgz"
  sha256 "290be3ffe1210b09e057afdc062e80ad6c6041d43ecc26dc4d525871eb1900e0"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "effa97994eadc1c5553cb50c4db4dd91ff61231df9d932655c096738d8e90475" => :sierra
    sha256 "c750583ced7374f450830aca131b3ac0c41048821e28c21242cffd4aa6aabf78" => :el_capitan
    sha256 "5db0a2a665b974f1d72a3a95ecb4a4b4a4e804de97d6210ba4cdc5df3d83a89d" => :yosemite
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
