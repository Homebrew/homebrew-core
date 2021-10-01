require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.56.0.tgz"
  sha256 "6c115002e166b6a354279988969f3bf1965426ca07c551d7bbb06d827afb9066"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83126a628c8efbb6c830f31ec4bb24c1185580414b67b3a30402e21f692abaa3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c0ac739d4d0e16510ff1dd03256b7cd42fd0fdef495f9172f57b6eb32a8f259"
    sha256 cellar: :any_skip_relocation, catalina:      "4c0ac739d4d0e16510ff1dd03256b7cd42fd0fdef495f9172f57b6eb32a8f259"
    sha256 cellar: :any_skip_relocation, mojave:        "4c0ac739d4d0e16510ff1dd03256b7cd42fd0fdef495f9172f57b6eb32a8f259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277f48d5b07bd710bbd2a5885f2576d3209810ff36c3737ea5754f8162cfd452"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.8.0.tgz"
    sha256 "013b570d1ae071834ba7552b2bb6b00c4bd467d417b7623ed55a0ce909c1705e"
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
