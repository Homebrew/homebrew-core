require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.3.1.tgz"
  sha256 "eccfbec7138188d6a9ae1516eeca07884399046d98e8e00841e5461ba054e166"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08f29c847af454c6c49c335bb29992044961b69df87d2ada3ae394c13b58cd9a" => :sierra
    sha256 "f6ddd1c2d399bb7a6a597a56a045b4659ec384a4738742b427bbd4b9dfcbb322" => :el_capitan
    sha256 "df3e800e372983ff35ad65aea75ebd81e18742e57f065421f88c0605232a5a16" => :yosemite
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
