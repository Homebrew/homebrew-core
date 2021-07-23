require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.46.0.tgz"
  sha256 "d218456290494dcab78d2d80efb4b8ba5383273a1473a01df0707943e1f602da"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64a72f62f25287d2f0e5d777fc544cd9ae3be644b6916e2ddfabb29ee3907591"
    sha256 cellar: :any_skip_relocation, big_sur:       "1386d1bf2f9e38597e1a2aaf81ff6b5fa419ebe003ed9ba26149d936203cf53b"
    sha256 cellar: :any_skip_relocation, catalina:      "1386d1bf2f9e38597e1a2aaf81ff6b5fa419ebe003ed9ba26149d936203cf53b"
    sha256 cellar: :any_skip_relocation, mojave:        "1386d1bf2f9e38597e1a2aaf81ff6b5fa419ebe003ed9ba26149d936203cf53b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa49c92a17aac55c868c236cd914f10766e4d235f2863216fbac956ff1a3f267"
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
