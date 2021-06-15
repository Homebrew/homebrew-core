require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.39.0.tgz"
  sha256 "7b83fdb849ce62cc660450c560005451a09bc046626dc398aaf1a3f5b9d134f5"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b7f52cb218817afe8052e34b033a291bd59e94d747ef987cd92f1a6bc90b998"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2ac2aead9bf7f9d8b3aa777a940ef505f14c16c1cb14508a2bdb77bd8726c71"
    sha256 cellar: :any_skip_relocation, catalina:      "e2ac2aead9bf7f9d8b3aa777a940ef505f14c16c1cb14508a2bdb77bd8726c71"
    sha256 cellar: :any_skip_relocation, mojave:        "e2ac2aead9bf7f9d8b3aa777a940ef505f14c16c1cb14508a2bdb77bd8726c71"
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
