require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.40.0.tgz"
  sha256 "7048aad388fe0f1fc350744a9eaa211b0a5f7b1f4bf4577e0e3b0407708c92d6"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "0eaa487f2766619382e65e2644cc7c8877b668ca05949fc155a3940a21efd3b5" => :mojave
    sha256 "780f810721f1b910b7e34c9dbb2029f1e310451b47a6abde4f9eba70b20554a4" => :high_sierra
    sha256 "1303c9197b913462c3426092607c33738cb536e212f3242b5fda656a15f9836f" => :sierra
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
