require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.4.1.tgz"
  sha256 "4193a3e7dd8cb524004ef4ce8092d5a9ee76eb02be614f6938d8869515935e4e"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "a5c79e78a9fb348a7c9931e4d6063d2942e37b68f89b8258d299c418203740f4" => :sierra
    sha256 "f5e08deb4cdd592c1e3b14b009aa85771689b8b4fd25557bd93a8d32965da9d1" => :el_capitan
    sha256 "eba8f6ebce7355575804e9509f61752407bd44b883859761f9dab8fae7fb09b8" => :yosemite
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
