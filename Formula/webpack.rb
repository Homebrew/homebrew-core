require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.62.2.tgz"
  sha256 "0719b0f7cf17d9fb5157c03afd6d6fb6216f8cd6ed3f70ed0f1da92c57762f31"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3055bb39cff5adf91256d2a84f2e2458dff68d358cfce501ee662f672ab20f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3055bb39cff5adf91256d2a84f2e2458dff68d358cfce501ee662f672ab20f7"
    sha256 cellar: :any_skip_relocation, monterey:       "373a27d786b827c7d17a63fa3e1e2b73a67124f446bff4114128e8839b9b9d91"
    sha256 cellar: :any_skip_relocation, big_sur:        "15e9f4b2fa4ecaea005fcec7e2f98b2be380d8a36e4be05f846b4e4df94703b4"
    sha256 cellar: :any_skip_relocation, catalina:       "15e9f4b2fa4ecaea005fcec7e2f98b2be380d8a36e4be05f846b4e4df94703b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3366ae6cd168d653119d3eca0b883309d287e16bec731499ada271b271c80c0c"
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
