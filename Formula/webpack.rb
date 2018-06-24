require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.12.1.tgz"
  sha256 "b0e154e237bb4e33d1d12aa95b584d18d27524edbaf8afb8e741088ef0dfb938"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "1552a3d7399401e6f134f98e86ff4d9403b51f8ba4da5cee101db1c56c1cae02" => :high_sierra
    sha256 "47fe41d11465133e7b78ec71e43977f114a18f74f34236e224c1ef374b7a6536" => :sierra
    sha256 "fb01401795f233248a4f2a1505dd3f27ef268aca67102f1233dc8dcd73f64637" => :el_capitan
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
