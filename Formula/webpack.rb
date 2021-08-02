require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.48.0.tgz"
  sha256 "982cb9b33c9d0d09a35370cc46ebaa05030cdc0027c34217b2bd770050c4448a"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "092a3a191698ef973ab70807a1808cb7dc5573d528293b5aa6519931e11afbde"
    sha256 cellar: :any_skip_relocation, big_sur:       "16e1796e2ef03f81eefd220775e97c28695582232981e5eddc3de84de08dbb51"
    sha256 cellar: :any_skip_relocation, catalina:      "16e1796e2ef03f81eefd220775e97c28695582232981e5eddc3de84de08dbb51"
    sha256 cellar: :any_skip_relocation, mojave:        "16e1796e2ef03f81eefd220775e97c28695582232981e5eddc3de84de08dbb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53aa08b34245dbd92d29fc162ed953029db42a77e4fe099f205a6df4c813d235"
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
