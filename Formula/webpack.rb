require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.64.0.tgz"
  sha256 "86a7242474750ff41f879c732b7b2093485d38ea343dfcf055fadfeb9f1d0861"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77cecc1928e4a1e9f6b166b8a9dffb818f7950b9b9a6044bd4616bfb79755fc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77cecc1928e4a1e9f6b166b8a9dffb818f7950b9b9a6044bd4616bfb79755fc6"
    sha256 cellar: :any_skip_relocation, monterey:       "e3a8719111c671dddf81e8c23ecb3dd46bd4487e5fd119df3c9fdeb040700677"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3a8719111c671dddf81e8c23ecb3dd46bd4487e5fd119df3c9fdeb040700677"
    sha256 cellar: :any_skip_relocation, catalina:       "e3a8719111c671dddf81e8c23ecb3dd46bd4487e5fd119df3c9fdeb040700677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3333ac7826746fee842190b00b168c49bf79237f6252e8a9e5fe780f83bdadf4"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.1.tgz"
    sha256 "0e80f38d28019f7c30f7237ca0b7a250dfe0b561d07d8248b162dde663cd54ff"
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
