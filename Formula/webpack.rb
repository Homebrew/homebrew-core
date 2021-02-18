require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.23.0.tgz"
  sha256 "2361f62638599ed83fa6cd10dfda5a47325ecf767a10a497afb9f0e498641aef"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f8374480574b02933b9982506c6f0ded11b391a22b83cc990d6738735e36b6cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a06f6c14c9ac5200f50197f329dc3d66600e47ec1836987652d85aa65ecd58d"
    sha256 cellar: :any_skip_relocation, catalina:      "4811b7a9a4e33dc9dd78fa0233e19e0d86dca5e977159cc7090e90bbc7062760"
    sha256 cellar: :any_skip_relocation, mojave:        "91b0e22754f822a762b12fce02ce8b49a0fb2e329c12a889d9a44a510a70b6b2"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.5.0.tgz"
    sha256 "6db23ada5a0ef82f6fd8f7c4b247589af6b6eaec36ef5e54f39660923a001679"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
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
