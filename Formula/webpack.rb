require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.13.0.tgz"
  sha256 "d6647bb6d93770ff8789e5b87225f537212ee85e7973d3233884b429198d0416"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "936701714dce84ffc92ee8f06269b4ee54b21044c32a05120c36330bb6751907" => :big_sur
    sha256 "80017a2f6d9cb88fcb7138655ee9681f7f3c7b05809155e599d233def4124ff7" => :arm64_big_sur
    sha256 "e512dc3581c9025b9226d07e33b0d313381307cd28606ad32eb53f0922184191" => :catalina
    sha256 "b964a4d561ce8aeb408f4be230c082a93e49282e4bb60530e6e9f3af235f3b7b" => :mojave
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
