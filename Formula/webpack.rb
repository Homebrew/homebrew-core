require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.4.1.tgz"
  sha256 "6c7998db7719986842886b77cbabb137639bc06541d093b567a4882c934bd61b"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ae226d55f9012a1a5efe89cacf2e8101571f5766950887e9763068d50bf1a1a" => :sierra
    sha256 "1521ff4c0d7d9b55c4df28cb4ad5afdc77f414459a62c741408c29d32d45db79" => :el_capitan
    sha256 "bcea126de1b6eb6e0160479bbffd7b46c2140772cd0a4ce12e0f11c5e6a4fa6c" => :yosemite
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
