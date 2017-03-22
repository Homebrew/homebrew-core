require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.3.0.tgz"
  sha256 "f0ad645072951231e7f29aa22f264c5f9d6499b43ca4b02e5afdaa68ad7b5545"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf53ea2b5e9b0afbc4158ae750a0cc8448eb8924cc10a1f738a5f34874839541" => :sierra
    sha256 "e5db4fe402fdd59fd8a0e0e7db4314f2ba7809ec82cc5b91b7806fadf0620dc2" => :el_capitan
    sha256 "a92855382a2368d42f0850dbc7a492c05dee3774e119c6ac1c81e6b6af3b861a" => :yosemite
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
