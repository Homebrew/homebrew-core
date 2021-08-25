require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.51.1.tgz"
  sha256 "bc03b801015b1743449bd96631541d7d6d3dc582fa3e8c980ab25ccddc7039fd"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f878d64b9050ddbcc3567b00044b55c78aa19dd05cbdc1d3669a9e068620ae34"
    sha256 cellar: :any_skip_relocation, big_sur:       "d51ed1a030ff4a52aa0ba564c8163a95944f5252895d558f47c09f295aee6ca2"
    sha256 cellar: :any_skip_relocation, catalina:      "d51ed1a030ff4a52aa0ba564c8163a95944f5252895d558f47c09f295aee6ca2"
    sha256 cellar: :any_skip_relocation, mojave:        "699c862e3139dd504a76db9502f0948cdffefc4e147dd996cb68656f1a947780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "634387c9221d6b15943f8a1d4740c217e560504b84916b285eb02ad85e71d0ac"
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
