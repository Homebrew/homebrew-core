require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.43.0.tgz"
  sha256 "757ce6ef5599d274d8065d2f1fb15ad6f526c4b5d3be820c6dcc62d7224927a4"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6926c83e88b6c9a76fb213d71ede0e03bda394e6de3ca87a3bb7f27127fb2fbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f3d302ffdc7bcc77b7f72a402687b5693e38b0986b8a4110e622ecd7a4bad2c"
    sha256 cellar: :any_skip_relocation, catalina:      "9f3d302ffdc7bcc77b7f72a402687b5693e38b0986b8a4110e622ecd7a4bad2c"
    sha256 cellar: :any_skip_relocation, mojave:        "9f3d302ffdc7bcc77b7f72a402687b5693e38b0986b8a4110e622ecd7a4bad2c"
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
