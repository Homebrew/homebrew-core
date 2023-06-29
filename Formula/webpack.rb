require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.88.1.tgz"
  sha256 "d407ad3e53b82daf03fc3f71d6471781169ff84f598476675ef721c28df09873"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47fa111594521a674afe460d93ab86d5a2cc5a658803789d1f22b0b94768660c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47fa111594521a674afe460d93ab86d5a2cc5a658803789d1f22b0b94768660c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47fa111594521a674afe460d93ab86d5a2cc5a658803789d1f22b0b94768660c"
    sha256 cellar: :any_skip_relocation, ventura:        "15cb248675fcf8124811a4fce26b7a5ffc69ac24f330b1362c5056621dac3e99"
    sha256 cellar: :any_skip_relocation, monterey:       "15cb248675fcf8124811a4fce26b7a5ffc69ac24f330b1362c5056621dac3e99"
    sha256 cellar: :any_skip_relocation, big_sur:        "15cb248675fcf8124811a4fce26b7a5ffc69ac24f330b1362c5056621dac3e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47fa111594521a674afe460d93ab86d5a2cc5a658803789d1f22b0b94768660c"
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
    assert_match "const e=document.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
