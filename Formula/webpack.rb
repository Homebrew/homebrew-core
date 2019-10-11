require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.41.1.tgz"
  sha256 "3fb19402c0c9fcff133224cbea045124fd65d5d56d75e801cb13286058978ab0"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "6d0bed0a779350cbc1906c96c76f87ef5bce53caccfb4fafe7e3c91f0aa71b60" => :catalina
    sha256 "8cdc8343e04f33f3ddb16068d9f781a3e10ed77c2b6aa08b5932e81a82f61f6c" => :mojave
    sha256 "6665210e136bee95cf4bee7ea2e20c99a005806060e432f0dd44d5cb184d0e89" => :high_sierra
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
