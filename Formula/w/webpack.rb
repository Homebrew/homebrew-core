require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.93.0.tgz"
  sha256 "3aa06fab2965c33d9b563affe86146bda627b0e872a57ebe94450f17260a9616"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71c5fb8088c0232d4907e7d91908fbf87370709c4ba310695bb676abbb2baed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c5fb8088c0232d4907e7d91908fbf87370709c4ba310695bb676abbb2baed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c5fb8088c0232d4907e7d91908fbf87370709c4ba310695bb676abbb2baed9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2df30c4bf157b8f4a74c66ef315a8ecc3284314a2f64b2ec80e39bd28475923"
    sha256 cellar: :any_skip_relocation, ventura:        "f2df30c4bf157b8f4a74c66ef315a8ecc3284314a2f64b2ec80e39bd28475923"
    sha256 cellar: :any_skip_relocation, monterey:       "f2df30c4bf157b8f4a74c66ef315a8ecc3284314a2f64b2ec80e39bd28475923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20cbcbf900e5beb86391f7fc151f9084e41ddc600581e00d29c3cda5830a1a1f"
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
