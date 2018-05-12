require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.8.3.tgz"
  sha256 "133454b1d9ba265049fe5d5e82266071063e26a366c3f2c05b230b0fae3ace00"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "a9d4723790e602678294b9f031c62c5094bb1d782c2ca033c7694e79999d0a89" => :high_sierra
    sha256 "6270a4104dba7c5fbbcec4049cbd28e211480c4a2f3444c55e2fbc280d9d6c66" => :sierra
    sha256 "18f8789445d2b72cd312912d132e1d4cc5a20ba4310e446c54629f382989ec75" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.1.3.tgz"
    sha256 "5587e4d8d14a122ee5130c27a5628f46774dfad432dd32175e4132bd6c3d345d"
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
