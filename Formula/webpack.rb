require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.4.1.tgz"
  sha256 "4193a3e7dd8cb524004ef4ce8092d5a9ee76eb02be614f6938d8869515935e4e"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "38b6cfbf8498678fa404193d5f770fa8b9079f163e613f22db6b19f2a2159c8e" => :sierra
    sha256 "2247ec35de86aa6a2940f18c8b825412a2274bfa89c389ae13d39020b4ca1162" => :el_capitan
    sha256 "250b426e6a088ff6ed596f7d8a825344d0fe7cba94064514164859bbaa48d9db" => :yosemite
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
