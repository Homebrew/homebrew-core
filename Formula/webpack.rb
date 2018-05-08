require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.8.1.tgz"
  sha256 "c8bf7bcc1d8f71ad554d731f054b827bf4766c48bbf1399858d9ec20594676cc"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "abb6d7d905f48cd80a9e647fb5a70f0762e35eb46235e3cb9bdfa75676fa708c" => :high_sierra
    sha256 "67017b517a02bc0fe2af5dffc41a2a2757845f51d42d3a0e702108b5ba8a8d4c" => :sierra
    sha256 "9d323ce78e3f44755bc0198dfc2fb1890d8560d1a1f579f97f3bf6223caa36f6" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.1.3.tgz"
    sha256 "5587e4d8d14a122ee5130c27a5628f46774dfad432dd32175e4132bd6c3d345d"
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
