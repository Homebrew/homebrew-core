require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.68.0.tgz"
  sha256 "a9ea29dd6e667ec56cae2893c160c8759a0e5f21f8e247bfd61ffd260569532c"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4c2acb16b038a676c0533919d6a120dd7ee9c8a76e2530a501cbc5c2af3157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc4c2acb16b038a676c0533919d6a120dd7ee9c8a76e2530a501cbc5c2af3157"
    sha256 cellar: :any_skip_relocation, monterey:       "efb0915510fe61725af4a1729f753edc07d961f8f1624c7b4f43e568a87b027d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ae7f22cca4c4fb87af5ec665488c0f8746246906fc2414b6129cc285b8db44d"
    sha256 cellar: :any_skip_relocation, catalina:       "5ae7f22cca4c4fb87af5ec665488c0f8746246906fc2414b6129cc285b8db44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a4919616b94ff3ad28be49280dd4b196beadeee13a9b4638a6e66f6b1d96714"
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
