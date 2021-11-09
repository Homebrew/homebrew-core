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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75091dfd5e9410d9304747a50ae5e537087a20c2321463586413488e2cdf75a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f75091dfd5e9410d9304747a50ae5e537087a20c2321463586413488e2cdf75a"
    sha256 cellar: :any_skip_relocation, monterey:       "0290e41a98df9e99b1f6e34ac8ad2e28b124842d9dde02044ace3e403eb15573"
    sha256 cellar: :any_skip_relocation, big_sur:        "0290e41a98df9e99b1f6e34ac8ad2e28b124842d9dde02044ace3e403eb15573"
    sha256 cellar: :any_skip_relocation, catalina:       "0290e41a98df9e99b1f6e34ac8ad2e28b124842d9dde02044ace3e403eb15573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc461ca55d981e0cc7f90f25080ec02345bfebed3c95d1c17fb29bb8c882c9c"
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
