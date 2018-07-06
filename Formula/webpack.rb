require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.15.1.tgz"
  sha256 "d6401193bf1f55c8e798d8cdc9ced0e0882d77aae93f96e3f37a3d6d20480adf"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "7299812b7951ac2b2dae6c5e338e91e43544ddeaed937442ec1bfe4319bb0930" => :high_sierra
    sha256 "ddf7d3d8b4de20792031ff2f390df38ff5363ebaebbf568c011dfc66438cb684" => :sierra
    sha256 "5baa69521a54ba34697040c715b8bc18f5ea4b6e59d866397cfbaf24b05042ec" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.0.8.tgz"
    sha256 "bad0d3c4a793e865217343aa60395cb4fa6309fcca1117554811fba723a8bb64"
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
