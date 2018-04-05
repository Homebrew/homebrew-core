require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.5.0.tgz"
  sha256 "8bd2521043e8da1edd93b346cd08215ec4dd71c7dfdef3526ae571f46000eb13"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "026f905a8a6147323eab73c7881ab927d22972a5b7c1b5278618801a10972ee1" => :high_sierra
    sha256 "22449741d67787d52d2f59627179c6413c550fe1288dac6be1b435d349545af4" => :sierra
    sha256 "7305e1bf09bd7b48f343b4c9ca9cfe558d63b6e5d9cf51dcd910a32366c4e449" => :el_capitan
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
