require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.99.8.tgz"
  sha256 "0476665eee672dc56cffc7338ee02d99ccf3c973780f304a02ff40e0d4850ee3"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f4b4ce9af0d015e07555b475d2c8c9bc8577ad214a43a2634e6512f0619e660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f4b4ce9af0d015e07555b475d2c8c9bc8577ad214a43a2634e6512f0619e660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f4b4ce9af0d015e07555b475d2c8c9bc8577ad214a43a2634e6512f0619e660"
    sha256 cellar: :any_skip_relocation, sonoma:        "b002daa84eaf9b68095b78a0925b04c40c63ce68f95571c0869b9dfbef3dfdd8"
    sha256 cellar: :any_skip_relocation, ventura:       "b002daa84eaf9b68095b78a0925b04c40c63ce68f95571c0869b9dfbef3dfdd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f4b4ce9af0d015e07555b475d2c8c9bc8577ad214a43a2634e6512f0619e660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f4b4ce9af0d015e07555b475d2c8c9bc8577ad214a43a2634e6512f0619e660"
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
