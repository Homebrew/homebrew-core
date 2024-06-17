require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.92.0.tgz"
  sha256 "095b6472d1da5bf13efd43a755298e0d348e062468e004799e89b7e449b4585d"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bcbb3f60ec51616da63c575dc81d0fc50f5786965c5e44a4415aa388b55cf11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bcbb3f60ec51616da63c575dc81d0fc50f5786965c5e44a4415aa388b55cf11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bcbb3f60ec51616da63c575dc81d0fc50f5786965c5e44a4415aa388b55cf11"
    sha256 cellar: :any_skip_relocation, sonoma:         "e89e24b08ef995a5344d2712b9a240260bdbcd7676754158f9b0151479107d15"
    sha256 cellar: :any_skip_relocation, ventura:        "e89e24b08ef995a5344d2712b9a240260bdbcd7676754158f9b0151479107d15"
    sha256 cellar: :any_skip_relocation, monterey:       "4f6ab56c479e9321e5a6b7ee31d6fbe07339c560580eb56af261f19782e8a718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba375d2d9265d5508d9cae197c02608d00b5d156d6c4488eda2f384467c97b0"
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
