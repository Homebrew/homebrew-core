require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.72.0.tgz"
  sha256 "2aeb4cf8d9fffced8a1fa24183dbe8d6a821c88662db6d2e019365db2fe5731b"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa9116caefa2cf8e0d9f2c8569decb340555a073ef950cad5a8da1f28a62e6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fa9116caefa2cf8e0d9f2c8569decb340555a073ef950cad5a8da1f28a62e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "8a89e48db42178eeadecb5eebcb0fe004e8265c84aa21fb6430e7d99e7d05f38"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a89e48db42178eeadecb5eebcb0fe004e8265c84aa21fb6430e7d99e7d05f38"
    sha256 cellar: :any_skip_relocation, catalina:       "8a89e48db42178eeadecb5eebcb0fe004e8265c84aa21fb6430e7d99e7d05f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0286ce5115ede0b64b7cc6395f5a539447b8faf28fc8e228af6ee6e1dc440e1d"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.2.tgz"
    sha256 "cec2b7fb5b49724b7642edf21ff7645ce5591cc65a24ba37b8fbe12086773189"
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
