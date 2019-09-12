require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.39.3.tgz"
  sha256 "1f682cea54f5b330bd99c4c35124fcfa097ef7d9eb0b15d7e44df6d9b28dd5ed"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "1f3c5c802b1642412397557714d77022ac53a1811aa2e264c39c3c11189db0e5" => :mojave
    sha256 "cada5e643c7590ffd0b1ad12f477341be4c400bcde7aff3904ecd8fbebcc1a24" => :high_sierra
    sha256 "7e810092733926202be68be88b4b0fa9b9e7537c318b05771354fcffd62191f7" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.5.tgz"
    sha256 "60254336b5994487f58712714b1b1a475e74dc1d0b3b3e609086096f445b1818"
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
