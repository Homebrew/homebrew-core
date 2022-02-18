require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.69.1.tgz"
  sha256 "885adfe442063b19c93eff6df1579feb5cf1cfceefd35317bb3c391816a33b80"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c68dc949c9af86b118432127d46f6e1c74efbb363564c6293a4b1e3c291c7bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c68dc949c9af86b118432127d46f6e1c74efbb363564c6293a4b1e3c291c7bfa"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d64012dad93e081ab0e4da63d96912e1101dbe4265ad80a5e3b4bc46ca3373"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1d64012dad93e081ab0e4da63d96912e1101dbe4265ad80a5e3b4bc46ca3373"
    sha256 cellar: :any_skip_relocation, catalina:       "d1d64012dad93e081ab0e4da63d96912e1101dbe4265ad80a5e3b4bc46ca3373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99b34196d0d4fe84800b5913e3df441cb018a8a60ef7c36e0f5ee79267265627"
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
