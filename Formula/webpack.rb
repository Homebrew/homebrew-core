require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.11.0.tgz"
  sha256 "cf8fc82308a8196eab9d2e905a645b9eb65d72b704868880110db34112b54ffc"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "896c209ed42f9c2bd51896ca597a1c937a73f2713bbf49869654ebac33f8bd39" => :big_sur
    sha256 "f52b8e83ffde803ab240ac22c2da9b89d9cd63f108588dd25fe8aaeb2e47af19" => :catalina
    sha256 "ed7f2a36400c04af40ff53f8de74e39bcf0ea7108536e58f95352c393de7beaf" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.2.0.tgz"
    sha256 "09ca2de6deee939a4a2f8edf206a776caafb6fe3590ed1a8310a3e3b69ad4a18"
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

    system bin/"webpack", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
