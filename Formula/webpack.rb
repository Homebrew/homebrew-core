require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.52.1.tgz"
  sha256 "316cb1e86a6a3441fabafb313e37f6a43d88e2d271d4ab6096283c475917d69f"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f68bad4a44d84afeb7825e42396484e4d2c0d072afb3d1373a43aed1d7827055"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a8662cc2e950a899a4f81adfbb73e93eb360df5147ad4559853538f25450b9c"
    sha256 cellar: :any_skip_relocation, catalina:      "6a8662cc2e950a899a4f81adfbb73e93eb360df5147ad4559853538f25450b9c"
    sha256 cellar: :any_skip_relocation, mojave:        "6a8662cc2e950a899a4f81adfbb73e93eb360df5147ad4559853538f25450b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a3ddba87dc2fcf390d10b59b10adbfe5012d75187f47af690eda29856fa7d2"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.8.0.tgz"
    sha256 "013b570d1ae071834ba7552b2bb6b00c4bd467d417b7623ed55a0ce909c1705e"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
