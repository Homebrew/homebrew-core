require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.42.0.tgz"
  sha256 "ac9d26d38622b700d7e67210c5f9ea2f9a76945276047119768480aadd7912b0"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "ca3b5407abb2fb8cae4c45c04175cd39c29e6e790ad9c9928ffa8ced1c9a713f" => :catalina
    sha256 "1efa057e881aaaa3d82702600e0bcb5fe893ca8af3fa26571ef21dce170855fd" => :mojave
    sha256 "d499077d3501b44d7fd93754593b1d7953d5616ea32d07ee2474ea6109099ea2" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.11.tgz"
    sha256 "dace2e99dc7b819b4695c69c327a0da9f56f799f15d20346b22a6cc22c5fb794"
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
