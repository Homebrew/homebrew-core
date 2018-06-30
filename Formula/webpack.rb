require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.14.0.tgz"
  sha256 "63f13a1be17278df14fbe61ac2dde0aad3f445c2c05090cd15307320cb06cad7"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "d4a013e73f37a07513ae43cacca73424ffc42d11121c928ea51faa996a5efa50" => :high_sierra
    sha256 "a75a05c0c543d8f7516dbdc351280dea61fc9e64a28fbf9447204acb7fd27f0c" => :sierra
    sha256 "52f474629d96cce55fe3c8b4b23954dccd9444db5040a0cb635a6e64bac0b8bf" => :el_capitan
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
