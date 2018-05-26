require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.9.1.tgz"
  sha256 "462c33ad1174fac7b18213d57b4989c2051bede8494d9a2d6dfc69058d5d74b1"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "a9d4723790e602678294b9f031c62c5094bb1d782c2ca033c7694e79999d0a89" => :high_sierra
    sha256 "6270a4104dba7c5fbbcec4049cbd28e211480c4a2f3444c55e2fbc280d9d6c66" => :sierra
    sha256 "18f8789445d2b72cd312912d132e1d4cc5a20ba4310e446c54629f382989ec75" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.1.4.tgz"
    sha256 "e3221dce3c49e0d491ee9f9d7c11832aa6cceb32790c3785532b9c39aad9ee8d"
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
