require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.1.3.tgz"
  sha256 "cfe19e27245e1c365ee517373d1c22f4dcf2f9ae6b6adcf81f33e58f0aee1f37"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "084398b30d0980dc3d96f346550ac3a15b1228b542af9f908a30a8c2a3db03d7" => :catalina
    sha256 "5ffdd83f04627ccdf04fe74b4d43e034501a85783e9fe0ed65ecec393128f746" => :mojave
    sha256 "ae6ff3f234aeb8987b354a178e2d8a6cc4b373c1035532842e4f2fe644a7453a" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.0.0.tgz"
    sha256 "ba846e71caddbf5a48b090f23f8ce91df6c771c72e324d1fb2b9eda6e2af1a7a"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundledDependencies"] = ["webpack"]
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

    system bin/"webpack", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
