require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.49.0.tgz"
  sha256 "677056d62b2d90ffc066bd08d2db62a28a12ec2718bd88a09db4b3251c93e596"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "723716818755a5f35c93f5c66e9e237941a27f10e5d636bfd6908f85bd1ee6b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "63f640c9bc46d7976bd3417e6bcc8116354108e029d910d45c46cb558cb86793"
    sha256 cellar: :any_skip_relocation, catalina:      "63f640c9bc46d7976bd3417e6bcc8116354108e029d910d45c46cb558cb86793"
    sha256 cellar: :any_skip_relocation, mojave:        "63f640c9bc46d7976bd3417e6bcc8116354108e029d910d45c46cb558cb86793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7e0f7c2a85a3497be30261c6f938b8110f1cfa9c38f6dec49e3ae43ea50e5a"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.7.2.tgz"
    sha256 "dce6cce3002e13873a36fb2c31034d9df20f4c68e3edecb93b9e4b71d2e32b77"
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
