require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.32.0.tgz"
  sha256 "f7c64853e33ebd82834b471a85b1e90dca787d2bf86d8468c19f75f379ebebd6"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "28b3cbfdede0edfcf66e9f31e175c1b8e4911f9a233a0c7a8c77055812dc4189" => :mojave
    sha256 "1bae5ab8f938ba4788a9da1109f0a50efa4a9e63167d080b715c1199805e515e" => :high_sierra
    sha256 "647496a3771a81e01c367418a6bc4fbda05dfc8bf0651e7e15acdf144a39d06a" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.2.tgz"
    sha256 "dcb31e31e1ffe79e97d51782a38459785f2ded99bc15467ffe35f9ac33146df4"
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
