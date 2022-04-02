require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.71.0.tgz"
  sha256 "7607130da6a3668e5a5ffd68d264c7e95d9ed3751b05b5bd733e8381f3ced205"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8b5b88b010eb5cd6d59006bbfbfdc0b12452c6a74ac935d52c59a69467d082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a8b5b88b010eb5cd6d59006bbfbfdc0b12452c6a74ac935d52c59a69467d082"
    sha256 cellar: :any_skip_relocation, monterey:       "65736f771ca376bef1fa3804134324a0c39556f86a34ddadebde23a913842924"
    sha256 cellar: :any_skip_relocation, big_sur:        "65736f771ca376bef1fa3804134324a0c39556f86a34ddadebde23a913842924"
    sha256 cellar: :any_skip_relocation, catalina:       "65736f771ca376bef1fa3804134324a0c39556f86a34ddadebde23a913842924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc936c7af6d0b583426b096ccfc97dcf8af9311024ae367ab00506be967cd50"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.2.tgz"
    sha256 "cec2b7fb5b49724b7642edf21ff7645ce5591cc65a24ba37b8fbe12086773189"
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
