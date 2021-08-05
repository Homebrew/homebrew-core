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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab0f289ebbe445bfbd1c7d2faefffccad2486b5530eaa3f88ab650e83aacf394"
    sha256 cellar: :any_skip_relocation, big_sur:       "38c91b5eab240135e2d4cb5b5967641154e497a7e76b11ff407da6331cec0613"
    sha256 cellar: :any_skip_relocation, catalina:      "38c91b5eab240135e2d4cb5b5967641154e497a7e76b11ff407da6331cec0613"
    sha256 cellar: :any_skip_relocation, mojave:        "38c91b5eab240135e2d4cb5b5967641154e497a7e76b11ff407da6331cec0613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa31abbc840e50cac416b12f7e5213aafb1430de7541773e294abb80c5d4d77"
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
