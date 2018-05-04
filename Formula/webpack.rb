require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.7.0.tgz"
  sha256 "80826960c9573a52f8bb2cd5d4113469d8411423b2f3a2a32816222a5365e5cb"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "79943f016868c45f23cbdb891b5ce7323e7315e717cbc60fa46aaf9fb4e8a3de" => :high_sierra
    sha256 "5793e779dbbcdba1c52a2a51e30f8488deff60ec0237511a1a37843750c253c6" => :sierra
    sha256 "0d95a413b5fdbb4c98f68a4ed44d6a9d2f094fb1ab4d6dad54686522d404a894" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.1.0.tgz"
    sha256 "f905afd98df01abec8dd54e6ebe94d3941df10257f96196e9d932b0fbb554368"
  end

  def install
    (buildpath/"cli/node_modules/webpack").install Dir["*"]
    (buildpath/"cli").install resource("webpack-cli")

    cd buildpath/"cli" do
      # declare webpack as a bundledDependency of webpack-cli
      pkg_json = JSON.parse(IO.read("package.json"))
      pkg_json["dependencies"]["webpack"] = version
      pkg_json["bundledDependencies"] = ["webpack"]
      IO.write("package.json", JSON.pretty_generate(pkg_json))

      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    end

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
