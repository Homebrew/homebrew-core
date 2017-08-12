require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.5.4.tgz"
  sha256 "2f55db36b46c8b345d58fe1e3bb457d91011e960db9556f8d4d0dc6abcd2bc91"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "67056718425b864200e47df2042eb85d86917938758e1b772a566735883eacb9" => :sierra
    sha256 "93d9649de5e8a5fde32e48a0df5fcb90aa9080994a41687f1c23dcc0b092c188" => :el_capitan
    sha256 "34a692cd0a5b7aa5b52dc0e44af878f7bd4c5b930cb2c4d7abad28a53a934253" => :yosemite
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
