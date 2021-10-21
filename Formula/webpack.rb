require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.59.1.tgz"
  sha256 "4ed8a0e6a6ecf3e697bd3f32bd900894427c113b178af8d7582b3d19d24364f4"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4baa7ae378692daf722be8835469348254f1e4250e5949ce999920ac8d220cd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2fb165f2097678a65ce905163e44a01e27a6e455a2ecd037d97e3cc2e069078"
    sha256 cellar: :any_skip_relocation, catalina:      "d2fb165f2097678a65ce905163e44a01e27a6e455a2ecd037d97e3cc2e069078"
    sha256 cellar: :any_skip_relocation, mojave:        "d2fb165f2097678a65ce905163e44a01e27a6e455a2ecd037d97e3cc2e069078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a4d6f0af40dfa3bcdee639187f8b1bcdd06154229169447c79ecc1018495b8"
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
