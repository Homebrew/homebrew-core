require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.99.5.tgz"
  sha256 "a7051d79ea226a69c948f77cd7c5a670f911353070a63a92ac6a6a9d320fe348"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aba2c94c5900ff7811cb25b2ab715e0a81c0e600924d62989d9856a1b3633a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aba2c94c5900ff7811cb25b2ab715e0a81c0e600924d62989d9856a1b3633a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aba2c94c5900ff7811cb25b2ab715e0a81c0e600924d62989d9856a1b3633a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "758b7180b99132b8ffe6f45c80a093ff8cae0919f77ae6ba087d4ee4c51e69ae"
    sha256 cellar: :any_skip_relocation, ventura:       "758b7180b99132b8ffe6f45c80a093ff8cae0919f77ae6ba087d4ee4c51e69ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aba2c94c5900ff7811cb25b2ab715e0a81c0e600924d62989d9856a1b3633a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aba2c94c5900ff7811cb25b2ab715e0a81c0e600924d62989d9856a1b3633a4"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-6.0.1.tgz"
    sha256 "f407788079854b0d48fb750da496c59cf00762dce3731520a4b375a377dec183"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--force"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin/"webpack", "bundle", "--mode=production", testpath/"index.js"
    assert_match 'const e=document.createElement("div");', (testpath/"dist/main.js").read
  end
end
