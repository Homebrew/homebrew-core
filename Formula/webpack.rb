require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.76.2.tgz"
  sha256 "6418fdd692295a1c8e89974bfed13ca487e55fe5f70efcea4473c04f7a4ac5a4"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449107f69e070faadbb933e922f6e22612adae8458158f8a2cfd03f8f0a0d49f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "449107f69e070faadbb933e922f6e22612adae8458158f8a2cfd03f8f0a0d49f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "449107f69e070faadbb933e922f6e22612adae8458158f8a2cfd03f8f0a0d49f"
    sha256 cellar: :any_skip_relocation, ventura:        "9f242d531fc015a940644cf7717013932f22471512136daa0b6a4a3ab10d67ba"
    sha256 cellar: :any_skip_relocation, monterey:       "9f242d531fc015a940644cf7717013932f22471512136daa0b6a4a3ab10d67ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f242d531fc015a940644cf7717013932f22471512136daa0b6a4a3ab10d67ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449107f69e070faadbb933e922f6e22612adae8458158f8a2cfd03f8f0a0d49f"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.0.1.tgz"
    sha256 "960a4dc593cea909c9a0f050d2e485291347e8e1de9e72c186995195ba9169ba"
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
