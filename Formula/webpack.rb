require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.6.0.tgz"
  sha256 "cfd266405676ca60bc4e88462f20505436aa7c8d835ecf2335e4de32174557c4"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "f3137a42603b979669e499a9a4b2bea14e3a7ed3e8823b66b056854af9aeabe7" => :high_sierra
    sha256 "3ab2b1771981dc0586cd1cbcedc8ad05a81a310cee1db910d24d5808458075fb" => :sierra
    sha256 "30b0e51722e9b2fc0fde442db5487e98a5535074dee920244ed21b43e85c72b8" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.0.14.tgz"
    sha256 "2b16e5d5ce247408571ee81f15df6bb283acdeec59a146c7feb35e98b4a1b275"
  end

  def install
    (buildpath/"cli/node_modules/webpack").install Dir["*"]
    (buildpath/"cli").install resource("webpack-cli")

    cd buildpath/"cli" do
      # declare webpack as a bundledDependency of webpack-cli
      pkg_json = JSON.parse(IO.read("package.json"))
      pkg_json["dependencies"]["webpack"] = version
      pkg_json["bundledDependencies"] = ["webpack"]
      IO.write("package.json", JSON.pretty_generate(pkg_json))

      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    end

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
