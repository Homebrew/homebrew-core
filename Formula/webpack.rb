require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.0.0.tgz"
  sha256 "352794f6d2b43d6f0c1ed37ade4a5fac3aa8d09314f3b64769e672865321a900"
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
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.12.tgz"
    sha256 "f0267a453af2f55aef74de7c72136c2aabf162b15e488da1c7eac9b0b55a3cb1"
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
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "--output=bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
