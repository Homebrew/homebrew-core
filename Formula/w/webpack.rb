class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.113.0.tgz"
  sha256 "095755cb8e271b3f38615ae794264f314b1e4dd3158c5677e8700aee9ea20bb7"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    manifest_sha256 "2a652d6f2e6f2dc7c1ed4f6b2ef06048fdbc4f9634b4e006094d1a29f77b46e5"
    sha256 cellar: :any_skip_relocation, all: "45bdf52e3b3fad78e82a36ce8f9b95c5e4d9b2a3fa5c9846b80ba091a4ccb711"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-7.3.1.tgz"
    sha256 "833aab597a1f8748bd943a961763fe4a5640c7efa6c6e5c0e88a497db90c42dd"
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
