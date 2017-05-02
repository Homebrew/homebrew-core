require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-2.4.1.tgz"
  sha256 "6c7998db7719986842886b77cbabb137639bc06541d093b567a4882c934bd61b"
  head "https://github.com/webpack/webpack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d3387e7084970cd6d9be909871b31ec6265bc68acc4861b0732525f938b94af" => :sierra
    sha256 "da1aedef083b3e640fdb1e497ab94d0a6bacc9ce478c9b5774ad7f41a143f7ba" => :el_capitan
    sha256 "c75f4c38f7d38f3dec66f0c0bca7e99ede6d30a3463e77b0c8f058bbed2ac051" => :yosemite
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
