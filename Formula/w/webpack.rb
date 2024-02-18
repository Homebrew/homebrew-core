require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.90.2.tgz"
  sha256 "d96010242658a2ac8fea4a1de2f0e6d6da2a4c92315a56bd84f627f65e2a1746"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b5e728cda9e51766e5191f9a00116a8bc8c534359102fe83035eb5bfb86ffaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5e728cda9e51766e5191f9a00116a8bc8c534359102fe83035eb5bfb86ffaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b5e728cda9e51766e5191f9a00116a8bc8c534359102fe83035eb5bfb86ffaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "de4e18776e0b1fa30646d539343c79cec60b495ad3b91573970fb0f62f292151"
    sha256 cellar: :any_skip_relocation, ventura:        "de4e18776e0b1fa30646d539343c79cec60b495ad3b91573970fb0f62f292151"
    sha256 cellar: :any_skip_relocation, monterey:       "de4e18776e0b1fa30646d539343c79cec60b495ad3b91573970fb0f62f292151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b5e728cda9e51766e5191f9a00116a8bc8c534359102fe83035eb5bfb86ffaf"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.4.tgz"
    sha256 "0d5484af2d1547607f8cac9133431cc175c702ea9bffdf6eb446cc1f492da2ac"
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
    assert_match "const e=document.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
