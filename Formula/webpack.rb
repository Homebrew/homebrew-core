require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.72.1.tgz"
  sha256 "98c9dc5a5d7a88e151af0d79f7257b8b6a9fffb41398edc56db065aea226da14"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6afba23bbc0af489b4f32aa1010f9d0dbb35094355ced592fc341a1f1c162580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6afba23bbc0af489b4f32aa1010f9d0dbb35094355ced592fc341a1f1c162580"
    sha256 cellar: :any_skip_relocation, monterey:       "1df3976e4b4830a5214e8948bf2dbc3ffe4dc3587629a1244b3fb0fda0482d04"
    sha256 cellar: :any_skip_relocation, big_sur:        "1df3976e4b4830a5214e8948bf2dbc3ffe4dc3587629a1244b3fb0fda0482d04"
    sha256 cellar: :any_skip_relocation, catalina:       "1df3976e4b4830a5214e8948bf2dbc3ffe4dc3587629a1244b3fb0fda0482d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2523104f314f17203d71997548cf9e0b9a2bef510570da1e6d9612da89dbd0"
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
