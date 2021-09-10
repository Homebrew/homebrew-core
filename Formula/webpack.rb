require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.52.1.tgz"
  sha256 "316cb1e86a6a3441fabafb313e37f6a43d88e2d271d4ab6096283c475917d69f"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8f1a1467d0442aed773567913d3a1ac39078ef6d0344ca18d7e752dcb3d99a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "158182bf8c44c0c4e1e288bb781c4e22a2f06be993ef8448889b1f1464b97852"
    sha256 cellar: :any_skip_relocation, catalina:      "158182bf8c44c0c4e1e288bb781c4e22a2f06be993ef8448889b1f1464b97852"
    sha256 cellar: :any_skip_relocation, mojave:        "158182bf8c44c0c4e1e288bb781c4e22a2f06be993ef8448889b1f1464b97852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9d9f621e8417f72d87cec7b28d0abe26174881984920205be24f989b358fce"
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
