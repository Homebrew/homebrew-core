require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.44.0.tgz"
  sha256 "b1cddd0c7e5f9cd493ed9079bd6aa33a1d0ef007878c49a6d4ee062806198d5b"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "154db5b4ee93f8bed3b6cdf809150bacd8ad2d7fbaa785b9472de41d5af6c0d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "a18d3dc5f602e92e9fb12ed6a7e45b123b0da4073a9a09d25bc76719c7f51996"
    sha256 cellar: :any_skip_relocation, catalina:      "a18d3dc5f602e92e9fb12ed6a7e45b123b0da4073a9a09d25bc76719c7f51996"
    sha256 cellar: :any_skip_relocation, mojave:        "a18d3dc5f602e92e9fb12ed6a7e45b123b0da4073a9a09d25bc76719c7f51996"
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
