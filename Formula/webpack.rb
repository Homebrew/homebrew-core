require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.44.1.tgz"
  sha256 "73c5f5f5a19953e688e07b2791369d6712369475314e64729d18b73426032579"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "1631af75c86867cbfb97d2b6e703a87582a2e93983300970f8fbc791948511b9" => :catalina
    sha256 "16381df12722dc30fc393fa170b89b022accbc2d16c7e94cbdcd4f08dd631499" => :mojave
    sha256 "20c38097a47f49d5d61f4007711e9680438b4e09d07e22e94defd041cf5f96cb" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.12.tgz"
    sha256 "f0267a453af2f55aef74de7c72136c2aabf162b15e488da1c7eac9b0b55a3cb1"
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
