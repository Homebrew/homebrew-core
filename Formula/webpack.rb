require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.42.1.tgz"
  sha256 "5fe9db7590d561fe07c2514079f17881a2417aabd726c152140ee4c32095d115"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4059d259f715545ed0d7e7cdf493aab6789e18923edd5f923bc351aca4fe464"
    sha256 cellar: :any_skip_relocation, big_sur:       "20ef2215aca35643add912fcaaf62ff6c2a116a55d7d279cfe9d3fe2f064e893"
    sha256 cellar: :any_skip_relocation, catalina:      "20ef2215aca35643add912fcaaf62ff6c2a116a55d7d279cfe9d3fe2f064e893"
    sha256 cellar: :any_skip_relocation, mojave:        "20ef2215aca35643add912fcaaf62ff6c2a116a55d7d279cfe9d3fe2f064e893"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.7.2.tgz"
    sha256 "dce6cce3002e13873a36fb2c31034d9df20f4c68e3edecb93b9e4b71d2e32b77"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
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
