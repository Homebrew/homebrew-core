require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.25.0.tgz"
  sha256 "726c6c8df211f9abb76a4b7af27b818bf42546ac9a5f6dd870cfbf19d4b69bc7"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "28126280efe55111ac7a5efb1686f33115010e6d3e6b74c7634fd596ff2cee39" => :mojave
    sha256 "c50d1d67e4a6d47a6645ae187c3fd74ab53572a174d744c5a5954f78eb17a922" => :high_sierra
    sha256 "a2d112029573ebfdcd7a0c2a6417dc7582c1e1e0d98de8b0d070eec1fc0185a9" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.1.2.tgz"
    sha256 "135962a43cdec4d24f68925c32e4daea600d6433d7b8fb912a9709a65712411e"
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
