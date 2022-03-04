require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.70.0.tgz"
  sha256 "ae0c864188574863a49a3f631080afb85bb350e4d3e66f83698a1c748c12bb52"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2058cda3eddf0616bbada0b937f896bf86f86bbe563651882514f0a286d17bb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2058cda3eddf0616bbada0b937f896bf86f86bbe563651882514f0a286d17bb8"
    sha256 cellar: :any_skip_relocation, monterey:       "0b1e99caf8c8890de096b0f2c3b19dca5e7aa58d28a6ae302c785ee427480017"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b1e99caf8c8890de096b0f2c3b19dca5e7aa58d28a6ae302c785ee427480017"
    sha256 cellar: :any_skip_relocation, catalina:       "0b1e99caf8c8890de096b0f2c3b19dca5e7aa58d28a6ae302c785ee427480017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b30a528181f5e97aefe2903ed6c33ff30e949b8d545287fe00a52ad9a11a1e"
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
