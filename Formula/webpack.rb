require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.4.1.tgz"
  sha256 "a381bcc41bf295f80959d1c83409f7823b82fd8dc2ca663a5ea64cc6abf74d88"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "d109dde096cbb3797789241b7689a1f0262d7d3740a6e7d4c3735ae1b507a40a" => :high_sierra
    sha256 "7a2df1d28e5eb5710c5596f84344879a56bc57958142325913d04a550ceed660" => :sierra
    sha256 "cf56cb1ebe3a1dc7441375a6ac1b145f0d1f063c5b191160b2f483ea961ca726" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.0.13.tgz"
    sha256 "971d03c08c3d6b13b8c3f24b3b76ddd1da8a9fb6c9754abac03ad41fbaadeabb"
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
