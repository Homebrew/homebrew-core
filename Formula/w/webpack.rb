require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.109.2.tgz"
  sha256 "3edd36c4196801c74b283e8fe662e1fdb9965a947bf996d487d578422539925d"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b56aab962de498a33f9d966babe9edb976764d96c660926e2f978936ad7f9168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56aab962de498a33f9d966babe9edb976764d96c660926e2f978936ad7f9168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56aab962de498a33f9d966babe9edb976764d96c660926e2f978936ad7f9168"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d5fae456accab215aa861b1482aff0ab932e8639db983dce2caa7d958001af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56aab962de498a33f9d966babe9edb976764d96c660926e2f978936ad7f9168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b56aab962de498a33f9d966babe9edb976764d96c660926e2f978936ad7f9168"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-7.2.2.tgz"
    sha256 "95bfe3dd162da7c65fdfa4bacbfba6bc8a157cc4ae470afab5689f20c6c26e74"
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
