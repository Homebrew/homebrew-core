require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.17.0.tgz"
  sha256 "0e65fbdbd6e9c5a281e75665ffbbc35480f51a8cd0c0bea77b82f7d850e91939"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "de86ee2088e739f6b189b0544a5a4cfd7e87c38ad970ffa4ad8e3b4ce572d9e7" => :big_sur
    sha256 "b2ed217ecc6a122e49cc72b7215bf7f817231527ce8f91d33c334f7bfff24f61" => :arm64_big_sur
    sha256 "77a1bc04d4eb47902c4d23cff67146a91cbc424fda47f624b91b4bc55013f286" => :catalina
    sha256 "5338918a409dc702c62cd3fa515dd51dbe19a5e332a8a672bd110b6dcfcc6d08" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.4.0.tgz"
    sha256 "11fcc682d0a7ec669415518b80c874be348d865997bddf8a2b8cd801918157ae"
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
