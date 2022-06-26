require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.73.0.tgz"
  sha256 "10467b3419f790661bb801c168e61e88b5fa3d4ad70c0fc6b4c6b0b8fb4ffd0c"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eebf410b88c000870f12c485eeabb07676a6d8252e59923d00d99aa717cb99b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eebf410b88c000870f12c485eeabb07676a6d8252e59923d00d99aa717cb99b"
    sha256 cellar: :any_skip_relocation, monterey:       "227ccf427a230aa7d690ef6cbec49cde09455c48487aed40809904e5876b4b84"
    sha256 cellar: :any_skip_relocation, big_sur:        "227ccf427a230aa7d690ef6cbec49cde09455c48487aed40809904e5876b4b84"
    sha256 cellar: :any_skip_relocation, catalina:       "227ccf427a230aa7d690ef6cbec49cde09455c48487aed40809904e5876b4b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f947d1a014dea4ef153657a9ff6e10922832add3d49861152720eec95e7496c3"
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
