require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.21.2.tgz"
  sha256 "cbe925840d06bf86290efba08a64f33b8e7d0a4c523f9b0891215a40abfeb760"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27f97e52b160a1ee4dd8cd55248ee5f73e287f6719d5cb135aa95c77017eb104"
    sha256 cellar: :any_skip_relocation, big_sur:       "e24b87896a85ef376fed4cba264d33d585f66cf3c5241ba5d8fe8ff64c596aae"
    sha256 cellar: :any_skip_relocation, catalina:      "b41b0becbd19d961b22033229ee64e816ae093b074b7ea868a5d1c3e834fd4ba"
    sha256 cellar: :any_skip_relocation, mojave:        "1ec97af8a37ac5284ae5cbcb06f105603d9cc3e64f04889761a402adc5ac7e87"
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
