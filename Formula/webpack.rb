require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.15.0.tgz"
  sha256 "9be7d224c654faf9f85954b01559554a602d5b1a4d48badf8a52391c1829f075"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "abfe6cebca24228c7e5a014e473261c72d9e2486d94c3ec9216b5d6c9b0cefcb" => :big_sur
    sha256 "6c9e36beb8c38d6c1b9d8ee24a34d3f3d51e573209c5109e7b8417f3219771f0" => :arm64_big_sur
    sha256 "cd850eb401ab51140aa3f7206d130fcf30a8a80144af3b7ef1b4a681b2f8c280" => :catalina
    sha256 "d4e5345d0eae8fa70cd1d1d205c3229c40b9255d3dc8d5c96c979ce6cbe3447d" => :mojave
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
