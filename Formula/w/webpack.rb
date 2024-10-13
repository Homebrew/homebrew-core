require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.95.0.tgz"
  sha256 "f2af5e3bd812296e13230723c11a8bb9338cb175fc4d852934abf4868569d27e"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d06566fabf801d582c5631556e09defb51058f5864a4fe861b012f50e58449e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d06566fabf801d582c5631556e09defb51058f5864a4fe861b012f50e58449e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d06566fabf801d582c5631556e09defb51058f5864a4fe861b012f50e58449e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce1453a5aa3752e4776f4a21718a41eb61cf523cebfe752c4a4aa75235a66056"
    sha256 cellar: :any_skip_relocation, ventura:       "ce1453a5aa3752e4776f4a21718a41eb61cf523cebfe752c4a4aa75235a66056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d06566fabf801d582c5631556e09defb51058f5864a4fe861b012f50e58449e8"
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
      system "npm", "install", *std_npm_args(prefix: false), "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

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
