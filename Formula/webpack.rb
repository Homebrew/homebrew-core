require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.5.4.tgz"
  sha256 "2f55db36b46c8b345d58fe1e3bb457d91011e960db9556f8d4d0dc6abcd2bc91"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "ced7b5f9562ebef864310d310b9d98c0fed75045e2e0dd184d7ffdc9445b68bb" => :sierra
    sha256 "e751f1f9d66543058dadfeb029e12a63b59801190b28863bfd2086f1eb814c82" => :el_capitan
    sha256 "dcd88d6608fa9e40252b28971c7e693446afe3d294a2e909b532f75379563886" => :yosemite
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
