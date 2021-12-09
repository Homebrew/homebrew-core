require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.65.0.tgz"
  sha256 "da4f0f7172391d5ab522cc06e7c82ad825e967e11b6020e72f510563319eff31"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "124e411b0433d1019207ac3155abb98b2b23c3fd15574924b20f4227807ff328"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "124e411b0433d1019207ac3155abb98b2b23c3fd15574924b20f4227807ff328"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f8e5e5c71de23a393a04a8ec13784c707aeba1d71bbc4fe231db7f11d35871"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1df19cb2ff602d7cc94125901a915b4f0b5b5fcb9c709921a7d07f57fa22d2b"
    sha256 cellar: :any_skip_relocation, catalina:       "c1df19cb2ff602d7cc94125901a915b4f0b5b5fcb9c709921a7d07f57fa22d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d84f611525dfb039752f42666c2d3f9ca1a4e424de77874be9184c5bddf2d31"
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
