require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.40.2.tgz"
  sha256 "4201f34580219e5c8aae435e5781b1e2390f8d5f2155cd83eaf97cc59e632ed6"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "4564b9e000343d37d5449a963f373182f9d629194938885662cfaddfdafcb2b1" => :mojave
    sha256 "3c7d1a410dd16f3b6df3a05de6f2a85c4df73b897b37428f8a05643fb408e307" => :high_sierra
    sha256 "e53984ca458dd5b94c5f0b8a869fab916f10113450050cf4848e54cb132d4829" => :sierra
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
