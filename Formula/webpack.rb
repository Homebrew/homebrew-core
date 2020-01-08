require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.41.5.tgz"
  sha256 "d8e3aee9a8a9b32f98aae370410e81261bb24b65ccb31e2b2f885b75318b268c"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "66f133c79da2560585f4c8f429a1d413657586128694ec2cea28147fec3a4191" => :catalina
    sha256 "ae6a6b3d276fd6e166cf4828fe2f39e83cb0185365b86adc6a3b8222a714b823" => :mojave
    sha256 "2e88dc551b38cba3e7e434e64149e95481d04b4c571435bbade87f076048070a" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.8.tgz"
    sha256 "a198025f402cb37d0e44329ff35fb8dc3bb74c5dd533d299b2997a0b4fc5973f"
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
