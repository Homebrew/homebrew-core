require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.10.0.tgz"
  sha256 "e5c74086f1c927df8ecb11dc03510c5fda6a9e5543a4da1b2daf827cba5548e6"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "badc72c0107bf0596a97342e1bcf9e0d09794a595e06aafcc66ffa26ca3e1b91" => :high_sierra
    sha256 "fbee2b4dcd05493ab157833cacca434bf2b606cd6dd767dcf8c51e5210e694a9" => :sierra
    sha256 "cbc8043ee4c47563c6967168a49387cfca4628ed964c18da422e9092fe88f732" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.1.4.tgz"
    sha256 "e3221dce3c49e0d491ee9f9d7c11832aa6cceb32790c3785532b9c39aad9ee8d"
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
