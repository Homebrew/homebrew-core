require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.91.0.tgz"
  sha256 "473b007db06efe48024180a50c600384596abfc5f4e2b749a77f33d753bd2327"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7af2f6271422901919c6e8db5ad5eac3f7b995054f9288df975aac0da80b7fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af2f6271422901919c6e8db5ad5eac3f7b995054f9288df975aac0da80b7fd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af2f6271422901919c6e8db5ad5eac3f7b995054f9288df975aac0da80b7fd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9700817ce63c0ce855270ec140d180ba4f429fed5640bc7d45895b717d62971"
    sha256 cellar: :any_skip_relocation, ventura:        "d9700817ce63c0ce855270ec140d180ba4f429fed5640bc7d45895b717d62971"
    sha256 cellar: :any_skip_relocation, monterey:       "d9700817ce63c0ce855270ec140d180ba4f429fed5640bc7d45895b717d62971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7af2f6271422901919c6e8db5ad5eac3f7b995054f9288df975aac0da80b7fd0"
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
