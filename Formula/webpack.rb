require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.41.0.tgz"
  sha256 "88dfba4aeb4dd2373bd0fb331c31bc52ec0f0397f45f24892e8c8c20a8db6434"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "db70769aec9cbbfa64934f12de6413c8db89cd99732a51f840eae9e831b884e4" => :catalina
    sha256 "117facfec049c67d7a40452324f899cec6a8961911323e14e09eaafe0cead173" => :mojave
    sha256 "a9e691e2fe91b4ce05863b6bb294377d58bfd64a67378728b8f862396a6d4967" => :high_sierra
    sha256 "ecf348184422e6077353080187b6bb20126c887f0f01fa59bf21f59a07da5674" => :sierra
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
