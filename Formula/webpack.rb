require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.11.1.tgz"
  sha256 "6cdf85a6b97add85c193e8b19e6c139afd90f38075cd18471396ed2b39d71f28"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c2ebd9cad7f2b642264f15666283a50305c6950509d025e52706980721ae6a37" => :big_sur
    sha256 "84c6816293c4065037800196ddeabeb6c9209be47c3248d71ff7a851eb4f84a3" => :arm64_big_sur
    sha256 "253d5b31cc29da6c3419d796f6d0e70371a984ba91f6bc03d3a3b8bb69cd7aee" => :catalina
    sha256 "53a73b0092cb4427a443ed30cf8fa26f01e9844d159b1c082a3b2d07d69ddcc2" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.3.0.tgz"
    sha256 "57afd30af81933603c253ed4894bb56d589c8d3413271cdf01e81f89fc0fc6cc"
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
