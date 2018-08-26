require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.17.1.tgz"
  sha256 "9b4ac8e32b079241f481978e46238781da790df985228e84561f112883897623"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "6a7b3a3438ca10ced2f1a18896d75f84974043aefb2de7512219630eb65cb8ec" => :mojave
    sha256 "5ee69dd04a91f435083f02d4d540cd8d2dd2a591f6b0158e3995d2f01f88b9b1" => :high_sierra
    sha256 "770ee6ec89545120289cd71e5b7d6599d5cf519637dc7fdd11ed21675e3d07a0" => :sierra
    sha256 "1981ebf97e2812e341873bd12df106c4662b253a57fd5207eff41123b8acba87" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.1.0.tgz"
    sha256 "813af78013aed28a967d2227c17b9c81c4809ed68b4f324a22e703167ea01e73"
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
