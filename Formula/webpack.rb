require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.87.0.tgz"
  sha256 "5480fe52097ebcb3714cd3329ed59c697bd760d8f7fb1dc37486f5f411eb3fbe"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e0706f95ee4ab7ce14347de54dc83a27b20d28c6c13b1f41d88ff1116f9dd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e0706f95ee4ab7ce14347de54dc83a27b20d28c6c13b1f41d88ff1116f9dd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ef03a83764c47a6634a028af33371747cd7656b44b3833e89d4ba3b4eab11eb"
    sha256 cellar: :any_skip_relocation, ventura:        "94025cf4f9330018fc2c2bf705222b634677ba5017f36a29c5a904ef48680001"
    sha256 cellar: :any_skip_relocation, monterey:       "94025cf4f9330018fc2c2bf705222b634677ba5017f36a29c5a904ef48680001"
    sha256 cellar: :any_skip_relocation, big_sur:        "94025cf4f9330018fc2c2bf705222b634677ba5017f36a29c5a904ef48680001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef03a83764c47a6634a028af33371747cd7656b44b3833e89d4ba3b4eab11eb"
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
