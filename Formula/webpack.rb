require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.74.0.tgz"
  sha256 "7b46d1be31aab35758b9850c5a5d46fc818a63a0f0bd502b4d47428400dcc07d"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6e8407f8632e62886cab498aeb292c4db4c54872236d041f32c7b8242d26112"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e8407f8632e62886cab498aeb292c4db4c54872236d041f32c7b8242d26112"
    sha256 cellar: :any_skip_relocation, monterey:       "80c37f782d98e7f1be626dc4f3d6a03f80c1b6b2f6d460545198e64f2e66d57a"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c37f782d98e7f1be626dc4f3d6a03f80c1b6b2f6d460545198e64f2e66d57a"
    sha256 cellar: :any_skip_relocation, catalina:       "80c37f782d98e7f1be626dc4f3d6a03f80c1b6b2f6d460545198e64f2e66d57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c23ad9467c197bddc0e9a22f410c865d0a8dcafd44b2a094802400436c3672"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.10.0.tgz"
    sha256 "ac434f92d847c9b811154860071f217c871e6e008abbd8342fcc8e9f5faf7f99"
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
