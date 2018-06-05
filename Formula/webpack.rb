require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.11.0.tgz"
  sha256 "9eb5436d3710fe346a89b3a1beeaf1cf5c3de325abe1d631c1fea432eaf96d76"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "11f14845c409d7fce0dffd71a216f2c20d0da2649f955cca80164cf8372d19e0" => :high_sierra
    sha256 "295fa9495665ab6370f9fc00aa68104c14d492de056cee5ba022a8de24fe7390" => :sierra
    sha256 "d9719bedb58214c2e3ddb44104acda6d3e963260dfb7a8f98d18f3f48308885d" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.0.2.tgz"
    sha256 "3908442791e4b39c22ad13ba4226a3956637cb821c0c5859bfea60f3c38ec34e"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundledDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "--output=bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
