require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.86.0.tgz"
  sha256 "9ca870349e99efc271a529cc040c6c78e08cff999e98dbf9805cafceaeae93cc"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dbcf582d60dcf8e1b51ed632b37950d77a236b5efafdc27f202a7c9040dd0d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dbcf582d60dcf8e1b51ed632b37950d77a236b5efafdc27f202a7c9040dd0d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dbcf582d60dcf8e1b51ed632b37950d77a236b5efafdc27f202a7c9040dd0d9"
    sha256 cellar: :any_skip_relocation, ventura:        "e24d9cf19651be0eaa9d3f86bb569021145a69a96b11e4771ffc46589e94f236"
    sha256 cellar: :any_skip_relocation, monterey:       "e24d9cf19651be0eaa9d3f86bb569021145a69a96b11e4771ffc46589e94f236"
    sha256 cellar: :any_skip_relocation, big_sur:        "e24d9cf19651be0eaa9d3f86bb569021145a69a96b11e4771ffc46589e94f236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dbcf582d60dcf8e1b51ed632b37950d77a236b5efafdc27f202a7c9040dd0d9"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.3.tgz"
    sha256 "0f814cfa5fce08b19d47dcfa535ed4f44fbadb2bcafd3fe0b8a7b2481b4b4065"
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
    assert_match "const e=document.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
