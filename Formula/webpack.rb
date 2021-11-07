require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.62.1.tgz"
  sha256 "6c28f8abf238479060dcf03f25cbfefb36c7d52c8d8716bbf9dbc765031903b0"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4cb04663f65b0137e4e9fa655ebde16a0bcd4cdbc1ffaf931366bbe83b51c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef4cb04663f65b0137e4e9fa655ebde16a0bcd4cdbc1ffaf931366bbe83b51c1"
    sha256 cellar: :any_skip_relocation, monterey:       "6890880ba373b40ba20f7e8990c08f92f1d98b02e828838e0316db2a4809b236"
    sha256 cellar: :any_skip_relocation, big_sur:        "6890880ba373b40ba20f7e8990c08f92f1d98b02e828838e0316db2a4809b236"
    sha256 cellar: :any_skip_relocation, catalina:       "6890880ba373b40ba20f7e8990c08f92f1d98b02e828838e0316db2a4809b236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873a70e2adf432e6b9cabc52cb237f242efa4b2bd1674b9afa014d5e65c17bdc"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.1.tgz"
    sha256 "0e80f38d28019f7c30f7237ca0b7a250dfe0b561d07d8248b162dde663cd54ff"
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
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
