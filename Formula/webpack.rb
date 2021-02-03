require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.20.0.tgz"
  sha256 "c82c224958ceb8a5e3bd8067f26f6f4d03c5188e8e075ada72a6dc97ebda06b8"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "399515bf6aca099fb2f61637994baa46ceb5e190d72d12db4edc96fefad65335"
    sha256 cellar: :any_skip_relocation, big_sur:       "0df37ba08ba0a57f0618f4d5f8e64a5017bd4acf84fae9370a81c201f3a2116d"
    sha256 cellar: :any_skip_relocation, catalina:      "a7597689284bf6e567dbd8863e7d9f491818179933704e34b42439a1c4c2f755"
    sha256 cellar: :any_skip_relocation, mojave:        "b9aed7bc038f8274f5f7d6c8e43426e1d484b26696eac2ff8e72eacf32de0eca"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.5.0.tgz"
    sha256 "6db23ada5a0ef82f6fd8f7c4b247589af6b6eaec36ef5e54f39660923a001679"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
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
