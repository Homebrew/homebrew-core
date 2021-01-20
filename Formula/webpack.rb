require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.16.0.tgz"
  sha256 "e27904f89e5faf214489bba9f0ec5d84535444ed59bc2f24a3692529741f0b05"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cb097e1d89b243cafa9635edb0f1b7305f7b3674cf0d59a800b1e654a2907d64" => :big_sur
    sha256 "007bfddf21c30924e16c42547d8488025d2ca5c926e7ed4c8f227422fc37a21f" => :arm64_big_sur
    sha256 "d4230bd1685a7ca76ea9557fa5da689f6280a5fe449b48fd641e621eef31ad10" => :catalina
    sha256 "97f00469064aeae009b12bd238912d41db9ed9885db7e91e3ded9596e25ad5f4" => :mojave
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
