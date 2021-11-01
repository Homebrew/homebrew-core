require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.61.0.tgz"
  sha256 "11da93428974977f23f1d71fcd86d303d0ff3b31732d8c501782f0aae212862d"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948fdc87bd0ea0f67a637ff30d92488c72657c9d3e9636f671b76b336e9d6086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba7fde7e50af46e76246c7832e0fd252baf95acd67a4f5929a88c0f9cb70f8f5"
    sha256 cellar: :any_skip_relocation, monterey:       "3afc2a44676cd90f44aa913b3add47c37e529082b3c19518e26ddd902fcc0ccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "77879eb2da3eda9df20baa7754fec7ca20287407b6a28650fc1c5fc4e6a0519f"
    sha256 cellar: :any_skip_relocation, catalina:       "77879eb2da3eda9df20baa7754fec7ca20287407b6a28650fc1c5fc4e6a0519f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c809fe4156a44e6e9f826212ed4e3704118b2eecd1a0c3076130dcac347484ff"
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
