require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.58.1.tgz"
  sha256 "c13877bf1927b510000e34d380f7d422db5d83ae373f538fa9598db3b3acb73e"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc57a4c6cf6ac2c31a35d4e531b1d08ef7d5a9a0b993160dd91ca322ca0ff5f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "9462d8a017979ee75912a51665a1415544b5ae1e099e3118d696a52313398d78"
    sha256 cellar: :any_skip_relocation, catalina:      "9462d8a017979ee75912a51665a1415544b5ae1e099e3118d696a52313398d78"
    sha256 cellar: :any_skip_relocation, mojave:        "9462d8a017979ee75912a51665a1415544b5ae1e099e3118d696a52313398d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "127ac74be983430c3c37cdfa5c8a74ced7846b821dcbdb2863298dbb8966a4f6"
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
