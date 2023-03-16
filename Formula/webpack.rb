require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.76.2.tgz"
  sha256 "6418fdd692295a1c8e89974bfed13ca487e55fe5f70efcea4473c04f7a4ac5a4"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc0f59edc953fec15d07346613ab7a72f63336b6ecb9c0f16d1be0af334c48e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc0f59edc953fec15d07346613ab7a72f63336b6ecb9c0f16d1be0af334c48e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc0f59edc953fec15d07346613ab7a72f63336b6ecb9c0f16d1be0af334c48e8"
    sha256 cellar: :any_skip_relocation, ventura:        "fa8893f7e611f01372a07e73b78a45bd76c86a3398398b69607ca40342f16cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "fa8893f7e611f01372a07e73b78a45bd76c86a3398398b69607ca40342f16cd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa8893f7e611f01372a07e73b78a45bd76c86a3398398b69607ca40342f16cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0f59edc953fec15d07346613ab7a72f63336b6ecb9c0f16d1be0af334c48e8"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.0.1.tgz"
    sha256 "960a4dc593cea909c9a0f050d2e485291347e8e1de9e72c186995195ba9169ba"
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
