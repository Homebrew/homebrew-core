require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.43.0.tgz"
  sha256 "66d201133b2278182102c7ab65ebddf7e5015e5ee886a3e390802a958496e1ec"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "137a3c31a4207a5d89d0daa3623d2f43ea91df21cac555c3756318d10f9daeca" => :catalina
    sha256 "e07262fae60d677ad1420e71ea613fe3b50588aaf00a352aaa0b0c54ffb83c4f" => :mojave
    sha256 "dde296728283eb40c80175a6911c181223ae94c137f0b2eee1a2ca855d75a682" => :high_sierra
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
