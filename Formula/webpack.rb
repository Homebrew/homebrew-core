require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.75.0.tgz"
  sha256 "e733cae717d64669b6a638414f1b0361f822f15fd6987e5fb5c0eb281743b13d"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64dae4d651e7d6e4ccdf856ac5d619ca3c484fe637ff677dd4e61d6a5c84945"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a64dae4d651e7d6e4ccdf856ac5d619ca3c484fe637ff677dd4e61d6a5c84945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a64dae4d651e7d6e4ccdf856ac5d619ca3c484fe637ff677dd4e61d6a5c84945"
    sha256 cellar: :any_skip_relocation, ventura:        "808a689da5e87b61c7931561bf2f256b109f528048a8b74a5cf2ccae313ea800"
    sha256 cellar: :any_skip_relocation, monterey:       "0db9d8a423809eb9f5bfe88ec7db1ab9c04c12aed70657d8623acda44d3bf999"
    sha256 cellar: :any_skip_relocation, big_sur:        "0db9d8a423809eb9f5bfe88ec7db1ab9c04c12aed70657d8623acda44d3bf999"
    sha256 cellar: :any_skip_relocation, catalina:       "0db9d8a423809eb9f5bfe88ec7db1ab9c04c12aed70657d8623acda44d3bf999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4662df24c313a4c2eea8f298cde61f536353203539eac93ee9b204a3b6b792"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.10.0.tgz"
    sha256 "ac434f92d847c9b811154860071f217c871e6e008abbd8342fcc8e9f5faf7f99"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
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
