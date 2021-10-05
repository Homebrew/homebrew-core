require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.56.1.tgz"
  sha256 "f8b9e522b30c49921d257be7f6cf7aec6824660a6983e118c2f8354ba10eefd0"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c29b40b6d459ea3ed8d198a69ac46ccb0e29d273a617cec18b3338c278671642"
    sha256 cellar: :any_skip_relocation, big_sur:       "90de930c99e936d60bf5ff300ccfa63d4a0d57fed059a015315a23da37f3e6a9"
    sha256 cellar: :any_skip_relocation, catalina:      "90de930c99e936d60bf5ff300ccfa63d4a0d57fed059a015315a23da37f3e6a9"
    sha256 cellar: :any_skip_relocation, mojave:        "90de930c99e936d60bf5ff300ccfa63d4a0d57fed059a015315a23da37f3e6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9134e2dc58b59e8ba3a44bc114455f4b52b4f69c846179da5fb619e51dbef7bf"
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
