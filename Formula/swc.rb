require "language/node"

class Swc < Formula
  desc "Super fast javascript/typescript compiler"
  homepage "https://swc.rs/"
  url "https://registry.npmjs.org/@swc/core/-/core-1.2.82.tgz"
  sha256 "3fccdaae687c1f0e45106a6a86296a950d8c7e3228b8e8c02e7e662d7ae8d6e9"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "node"

  resource "swc-cli" do
    url "https://registry.npmjs.org/@swc/cli/-/cli-0.1.49.tgz"
    sha256 "c7b00a8b041ddaea64b9f47b9af8917d99c3f990ed3a3596eed9cc223b6aeac6"
  end

  def install
    (buildpath/"node_modules/@swc/core").install Dir["*"]
    buildpath.install resource("swc-cli")

    cd buildpath/"node_modules/@swc/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare swc-core as a bundledDependency of swc-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@swc/core"] = version
    pkg_json["bundleDependencies"] = ["@swc/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    expected = <<~EOS
      [
          1,
          2,
          3
      ].map(function(n) {
          return n + 1;
      });
    EOS

    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"swc", "script.js", "--out-file", "script-compiled.js"
    assert_equal expected, File.read(testpath/"script-compiled.js").chomp
  end
end
