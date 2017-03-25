require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.3.2.tgz"
  sha256 "323ed3f524d1fe118b2a62cb506fddd753d6ee33486b5c931dc7756df172a902"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d5534b627e90e3d055b49a5cf7ef216867c92b5830bf4ab3acbc9084ab4053a" => :sierra
    sha256 "39a535607e94b3982c84bb1cb2b774c7c622c7f4af57b945edfdbabaf1e5c70a" => :el_capitan
    sha256 "c4d89ea9e49c2224daaf5ea4fb92360d3cbf919e656ba37567a637490ce7e11a" => :yosemite
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
