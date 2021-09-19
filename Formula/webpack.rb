require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.53.0.tgz"
  sha256 "75309b6e81174e9b9541ee4764134bdc958fe3d961a3d0e269918f6e5e01c769"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d95d0956c278c47acca9bab857cc346bce96f2cc14fb3d76931146bf603109a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "062babe28a0d8a87a93482af514beea826da917b513205ff4fc62e46f158eb2c"
    sha256 cellar: :any_skip_relocation, catalina:      "062babe28a0d8a87a93482af514beea826da917b513205ff4fc62e46f158eb2c"
    sha256 cellar: :any_skip_relocation, mojave:        "062babe28a0d8a87a93482af514beea826da917b513205ff4fc62e46f158eb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1d7c8ebea86c9107d21ab1010e978c7c32046d6c65f4e4e53ffabec9af84e9"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.8.0.tgz"
    sha256 "013b570d1ae071834ba7552b2bb6b00c4bd467d417b7623ed55a0ce909c1705e"
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
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
