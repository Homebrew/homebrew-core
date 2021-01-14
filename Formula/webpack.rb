require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.14.0.tgz"
  sha256 "8020f7e6c4266a8c4bd659625dbf1b2ff9e4af2c177f4c5b52b11990e420638e"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a7fa256826e9a6d99ed5bf96b384d5302deebc71595683b4d67ea25c167fcc49" => :big_sur
    sha256 "ae30a3ec411af9273a04371ef7cf2bddb4640d03b349f7b54b2c15290f1e485b" => :arm64_big_sur
    sha256 "baaacbc85043ff42f575573be3ab6ac36f92aa0e2471791e6efc217a524ed0d0" => :catalina
    sha256 "9d78fdc16d24ec6a09e0a9ef4a25a707079bc41532ce8954af1ee1d4313353a7" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.3.1.tgz"
    sha256 "9d12d225e965d5c7d7d7145b215d297b93f47dc621f61a3185e0c69f09a64d43"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
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
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
