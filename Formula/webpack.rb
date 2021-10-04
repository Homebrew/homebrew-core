require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.56.1.tgz"
  sha256 "f8b9e522b30c49921d257be7f6cf7aec6824660a6983e118c2f8354ba10eefd0"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b93e2ad83d7c50368ac33175a7986e14fcf16d2390e86f09281ca05cd4b93309"
    sha256 cellar: :any_skip_relocation, big_sur:       "06d210f92db3a3561148a6397838945774ec7eb754176c66a7fd71ce2a699408"
    sha256 cellar: :any_skip_relocation, catalina:      "06d210f92db3a3561148a6397838945774ec7eb754176c66a7fd71ce2a699408"
    sha256 cellar: :any_skip_relocation, mojave:        "06d210f92db3a3561148a6397838945774ec7eb754176c66a7fd71ce2a699408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5adc83d4c8de4bfa37a2cb760a2bb84b40533f90f51963a0b869139c8117a27f"
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
