require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.89.0.tgz"
  sha256 "3237fadd6090e122bdd8187eb230581d15a0673a967a22d92a3f3d807ef1c7da"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "940f9aae43431dfc372075b5c1a1d8b9033b7ff714201ecbbce3326b681ba07f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "940f9aae43431dfc372075b5c1a1d8b9033b7ff714201ecbbce3326b681ba07f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "940f9aae43431dfc372075b5c1a1d8b9033b7ff714201ecbbce3326b681ba07f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8fd1e3848ce35ccf5d734c0e246e8943b80a4bff2a831cc21785b5b7962b6ac"
    sha256 cellar: :any_skip_relocation, ventura:        "b8fd1e3848ce35ccf5d734c0e246e8943b80a4bff2a831cc21785b5b7962b6ac"
    sha256 cellar: :any_skip_relocation, monterey:       "b8fd1e3848ce35ccf5d734c0e246e8943b80a4bff2a831cc21785b5b7962b6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940f9aae43431dfc372075b5c1a1d8b9033b7ff714201ecbbce3326b681ba07f"
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
