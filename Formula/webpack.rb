require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.55.1.tgz"
  sha256 "827a136a8b58433f41a1f73db28ffe0d9e8ddf4bc00672e15bd9cf367bfe3d87"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "186b3f2e70b54e9192cdff3a0e4dad07d7b98349bc58f20ccad16701f8e06ed8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a402b5cd51ac7e2dd3ee70513cb6f5f5d6ce27ae7b8ca153e0cc7ece303c0d3b"
    sha256 cellar: :any_skip_relocation, catalina:      "a402b5cd51ac7e2dd3ee70513cb6f5f5d6ce27ae7b8ca153e0cc7ece303c0d3b"
    sha256 cellar: :any_skip_relocation, mojave:        "a402b5cd51ac7e2dd3ee70513cb6f5f5d6ce27ae7b8ca153e0cc7ece303c0d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4c2d70364df95c454a3d7030c78924c11fad23c29827b7e45f15bbf9d13e18d"
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
