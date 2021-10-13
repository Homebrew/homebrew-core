require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.58.2.tgz"
  sha256 "53d252f873103c80e1122a8c3891d1742da820a8324f318456ee9437ade37012"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e9f4e06d7c179f57d15eba9a220112249c5af29e33a52b1a89a92822e268aa8"
    sha256 cellar: :any_skip_relocation, big_sur:       "08a60b9b6c42ddf0306020c89962e5860acb9a8cec7fdc9cbc28613920108121"
    sha256 cellar: :any_skip_relocation, catalina:      "08a60b9b6c42ddf0306020c89962e5860acb9a8cec7fdc9cbc28613920108121"
    sha256 cellar: :any_skip_relocation, mojave:        "08a60b9b6c42ddf0306020c89962e5860acb9a8cec7fdc9cbc28613920108121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7ae29c5c249ddc034d5f85c2419708cf4fe303087d7f12a6d99d2467316cd9"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.0.tgz"
    sha256 "d00063d3fe0ba978776a1dcfbfd1b0e03e84cde00169e94ccf7ed94f7d9703a5"
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
