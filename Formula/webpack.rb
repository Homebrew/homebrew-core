require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.60.0.tgz"
  sha256 "b349039b032932890d407a345f436d4e83934c5d837771cbf51b43ac577a01ff"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "944a9bf13d87459cb7f4fbedaed146472e5e693599dfa42b4bbbdd4c7fd35e68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d850e0ac1573fbbb072309e79d5613b638a0a7e1241bb6f74b68c0fc1c32456"
    sha256 cellar: :any_skip_relocation, monterey:       "2f0bb3b049467f3aaae720afdf298b8a3e39f349a7271c8dc92cfd394085d366"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1e4f6fe16a5ddce5545d18490194700a7cc9fece20d320b9bb6332dfb2e5bf0"
    sha256 cellar: :any_skip_relocation, catalina:       "b88b08c23dcbce741f6db8c69d4648335ef4c0058d07669300ca23fd77ec5149"
    sha256 cellar: :any_skip_relocation, mojave:         "ff0760feb90e3cb3db57b353b3a6c11b38b6b08bb7e53bb94c08413feffce87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34282e62605aa28e027dd4bafbff241f8fb486b118c97bfa7547b0e49ceea545"
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
