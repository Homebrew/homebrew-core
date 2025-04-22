require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.99.6.tgz"
  sha256 "a76b8e4fd4a508734ade13acfab6fbba628a19cdc45fce0ac48295b02c993b8b"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfd782f9338632d3e8b1429d39216f74cc5625b8016e26221b9e6fe2ee0d1ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dfd782f9338632d3e8b1429d39216f74cc5625b8016e26221b9e6fe2ee0d1ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dfd782f9338632d3e8b1429d39216f74cc5625b8016e26221b9e6fe2ee0d1ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a8f413af7fc78d172794ce6ea59888d37561a98d447d8556a5ca277cfbeac91"
    sha256 cellar: :any_skip_relocation, ventura:       "1a8f413af7fc78d172794ce6ea59888d37561a98d447d8556a5ca277cfbeac91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dfd782f9338632d3e8b1429d39216f74cc5625b8016e26221b9e6fe2ee0d1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dfd782f9338632d3e8b1429d39216f74cc5625b8016e26221b9e6fe2ee0d1ce"
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
