require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.2.0.tgz"
  sha256 "b26f5222183a875244b5d5eaa136557f2d2c0b9e7bdcc15c6755fd64bb3f2988"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "e7e203d228b8e1ef292042757cda099341e156da5f204a294e267cc88b97c077" => :high_sierra
    sha256 "fe88622d32152ab40d7692fbcea1b2ad2a3c1ef9b463af3816936773a8864644" => :sierra
    sha256 "a0bff460e34617045ab35e5195bd9df139caa46ebdfc45e0f3be7cc7dae593cd" => :el_capitan
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-2.0.12.tgz"
    sha256 "8ca6db07dfb6c2257522429bc63bb48d686eed05eeb3b1a594b6b1ab79f59ebd"
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
