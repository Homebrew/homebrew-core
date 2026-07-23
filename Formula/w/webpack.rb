require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.108.4.tgz"
  sha256 "9417ae009a6cff635b8c2df617ef967919dace2630506a712583cdca71995d49"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c397696aaf85d73568c4bad4f50b196b0789d69ec41fd1aae74cd61fd93c477"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-7.2.1.tgz"
    sha256 "1b1a572f4526fac81f8a8d2ab2a866ab763ec391b37e24d99bcbcdc8f08f92d8"
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
