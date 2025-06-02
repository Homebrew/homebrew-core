require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.99.9.tgz"
  sha256 "2382f23c1e85641b38cc9d374ca3a50d8c396a51925dfca5f0e747a35f356675"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07657efb363021560696bc20f052f629c2135fee7f7d528dc3f9f48ff034f4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07657efb363021560696bc20f052f629c2135fee7f7d528dc3f9f48ff034f4cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07657efb363021560696bc20f052f629c2135fee7f7d528dc3f9f48ff034f4cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "06f3bd933cafb18ee7e02eac3d4288b9a3b6dcc82d0e30067c2279a9a21ecc74"
    sha256 cellar: :any_skip_relocation, ventura:       "06f3bd933cafb18ee7e02eac3d4288b9a3b6dcc82d0e30067c2279a9a21ecc74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07657efb363021560696bc20f052f629c2135fee7f7d528dc3f9f48ff034f4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07657efb363021560696bc20f052f629c2135fee7f7d528dc3f9f48ff034f4cc"
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
