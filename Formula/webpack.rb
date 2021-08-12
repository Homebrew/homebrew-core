require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.50.0.tgz"
  sha256 "f1df466b7564da0352f9f0f3e9d77670a9a315ee54c0f9b65dffd0761761641d"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be7d1c91d7a001ac51b8f8c85808cc348b59e4a7308de9d5e64ab77c9155191a"
    sha256 cellar: :any_skip_relocation, big_sur:       "de4aaece84d277adb9ac78951c952a897531df4d20b7d7be25369e33277d7cff"
    sha256 cellar: :any_skip_relocation, catalina:      "de4aaece84d277adb9ac78951c952a897531df4d20b7d7be25369e33277d7cff"
    sha256 cellar: :any_skip_relocation, mojave:        "de4aaece84d277adb9ac78951c952a897531df4d20b7d7be25369e33277d7cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7d1361fef8e13932deb3f01d3ec6b6d16408fc428a9fba4719d5315e9e0145"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.7.2.tgz"
    sha256 "dce6cce3002e13873a36fb2c31034d9df20f4c68e3edecb93b9e4b71d2e32b77"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
