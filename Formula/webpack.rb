require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.52.0.tgz"
  sha256 "607e6abbcab0a9ca467637e93e357c31260e06c0a345eda0b5d62b34f67d7bc9"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb0a6a625971b3fd64fbc1fc258e89af79f86aa49a0278c1f93b9bf5a840839e"
    sha256 cellar: :any_skip_relocation, big_sur:       "03b873299f79c886782f09797cc532cc7cf218cf6cff1d06b684c8847a6dae23"
    sha256 cellar: :any_skip_relocation, catalina:      "03b873299f79c886782f09797cc532cc7cf218cf6cff1d06b684c8847a6dae23"
    sha256 cellar: :any_skip_relocation, mojave:        "03b873299f79c886782f09797cc532cc7cf218cf6cff1d06b684c8847a6dae23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb817ff5134fc94b9ab33687e12c35f2fec7982c2fe4e7e791147d8b317418f"
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
