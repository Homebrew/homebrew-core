require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.5.0.tgz"
  sha256 "a32b81660203b389af5ddadeb35dee657c6176bae183cc8a2754223de120dc5e"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d42fb45065f8931e88b95d5377d09e182bdcf3684afb5c89e2b8bdcd7b7b583" => :sierra
    sha256 "eda89e06628b6f43832accd4bc59b3d63d8dc4a27a5eaa8a635a7856cc994ced" => :el_capitan
    sha256 "01920659f5681cb077a7195655e955007acca408d2eac9411aaab0d221614da3" => :yosemite
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
