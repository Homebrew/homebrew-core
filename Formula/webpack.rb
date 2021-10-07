require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.58.0.tgz"
  sha256 "682a74f9f756a9c89d99249490ca311593f2a6a13bbe189b5ddf148d310edca6"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3f20388212113a47526c1a5108c4356ec91c580c845c05cb51ff63eb039f0a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "505a1d7b8a131f4390e55f0487875c78083ccc60a94775c14c661cd568010a6f"
    sha256 cellar: :any_skip_relocation, catalina:      "505a1d7b8a131f4390e55f0487875c78083ccc60a94775c14c661cd568010a6f"
    sha256 cellar: :any_skip_relocation, mojave:        "505a1d7b8a131f4390e55f0487875c78083ccc60a94775c14c661cd568010a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b2064ffd41860f2cf011a6993bc02f1be51ac50e9e1be1637214f5d83c8b943"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.0.tgz"
    sha256 "d00063d3fe0ba978776a1dcfbfd1b0e03e84cde00169e94ccf7ed94f7d9703a5"
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
