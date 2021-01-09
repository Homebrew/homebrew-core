require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.12.1.tgz"
  sha256 "20b107928de0259b0e3c50014fe4dbc9197dae6595e6cace48c6a8bafcf7af10"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b9d086e12a33c0b3c2dcce4dd3697a87172ab3bcf07418db8507e5b8df0671f6" => :big_sur
    sha256 "fbd786d675dfaad4beb9f7940e2cb506f56c9d591b1a1f3bebb6c2b124a5d2ff" => :arm64_big_sur
    sha256 "a5fa281e496e46ca6dec99f7c417e38fa7d09be9b44a0ec38204c17bc4b48852" => :catalina
    sha256 "9775db0ba6289f38c13f8fd5618513b30c724238d2afced3685d09e9114664ae" => :mojave
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.3.1.tgz"
    sha256 "9d12d225e965d5c7d7d7145b215d297b93f47dc621f61a3185e0c69f09a64d43"
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
