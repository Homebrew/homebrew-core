require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.38.0.tgz"
  sha256 "ec86c13fa34fa93f008867de38f4603d66bb1e590459d3e8df5f0214f44020c0"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "445c871915deb45478132cf093ba915a99187ffaa402567eaa0cfe42cc666fae" => :mojave
    sha256 "17b3c25f09be75e28431f36e485c5f643a00a0beccb67140e6614e2cfe7f1527" => :high_sierra
    sha256 "b262dd3065ab4804dbd066c03d23591d0bbe1c9cf157de441b95e4aedb29c1d7" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.5.tgz"
    sha256 "60254336b5994487f58712714b1b1a475e74dc1d0b3b3e609086096f445b1818"
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
