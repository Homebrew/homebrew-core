require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.19.0.tgz"
  sha256 "f76d9b8d38efb87e52f98d161c50512a2b909a3e65091ded96bf5c222229d802"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fbf41b9dde7ad9436683de93d688e5fa8358606cb4ed5c871a865cf9c12c8c5e" => :big_sur
    sha256 "dd8dfaea3346d6e3b423bbf55af9814205fa0afc19c973d4f5f1b67e5636de7d" => :arm64_big_sur
    sha256 "d0930c0617a3719296c0d6a09eb21b4638ea68a50eb03a955f20b13140964898" => :catalina
    sha256 "4c4592876b11b6ec3cbc4b364301bbd93e2ae0e3922b5d1ee6ad90cfcd735a67" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.4.0.tgz"
    sha256 "11fcc682d0a7ec669415518b80c874be348d865997bddf8a2b8cd801918157ae"
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
