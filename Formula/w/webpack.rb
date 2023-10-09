require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.88.2.tgz"
  sha256 "4d92a947dbc855289a1a33a9a77dd9a2cf04606d721a74b18104de29aa1f8279"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a834d85b1c0fa4df4d7457ba4c3ef73f275195bff998c078025e478280edd22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43da3e72119ed6136f871990a187926fdb7399d76c90b9fff9e73993d2dac774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43da3e72119ed6136f871990a187926fdb7399d76c90b9fff9e73993d2dac774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43da3e72119ed6136f871990a187926fdb7399d76c90b9fff9e73993d2dac774"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f4130379e10f98d5a5785d15fdffbb66488f51140973fbba6bb3baba8fa7c37"
    sha256 cellar: :any_skip_relocation, ventura:        "5c6221f47a3266387fe4101dd465e37af6f8e660f69a5fd9428a678cdc986535"
    sha256 cellar: :any_skip_relocation, monterey:       "5c6221f47a3266387fe4101dd465e37af6f8e660f69a5fd9428a678cdc986535"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c6221f47a3266387fe4101dd465e37af6f8e660f69a5fd9428a678cdc986535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43da3e72119ed6136f871990a187926fdb7399d76c90b9fff9e73993d2dac774"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.4.tgz"
    sha256 "0d5484af2d1547607f8cac9133431cc175c702ea9bffdf6eb446cc1f492da2ac"
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
