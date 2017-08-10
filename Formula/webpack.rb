require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.5.2.tgz"
  sha256 "7e1c877dbecda530ab5bf1fe57e1da250dddc5798c1fa690145adb3b3c725482"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "435c0b1e4775f9626e2b3cb8f96936a95d687ae64f8a367f82c82fa1af1d4878" => :sierra
    sha256 "f17ef2a9085c3a8418191c7d79af4bfec4b36b8c14807fea30a089c4bb7b32f3" => :el_capitan
    sha256 "fda6b904ac9802658437bb4e6961cff8485154dca082ad8d099e525e48bdeec0" => :yosemite
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
