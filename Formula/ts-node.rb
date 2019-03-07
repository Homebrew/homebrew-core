require "language/node"
require "json"

class TsNode < Formula
  desc "TypeScript execution and REPL for node.js"
  homepage "https://github.com/TypeStrong/ts-node"
  url "https://registry.npmjs.org/ts-node/ts-node-8.0.3.tgz"
  sha256 "e3cb69b68d4974c456579cc48ba7d5f967e4a54e67e414ed672a30269e755054"

  depends_on "node"

  resource "typescript" do
    url "https://registry.npmjs.org/typescript/-/typescript-3.3.3333.tgz"
    sha256 "4af747947089d0a25b2b3dd45f892a63c576b97039cd57eb8cfc1d5ab00df3d0"
  end

  def install
    (buildpath/"node_modules/typescript").install resource("typescript")

    # declare typescript as a bundledDependency of ts-node
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["typescript"] = resource("typescript").version
    pkg_json["bundledDependencies"] = ["typescript"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      function sayHello(person: string) {
          return 'Hello, ' + person;
      }
      const user = 'World';
      console.log(sayHello(user));
    EOS
    assert_equal "Hello, World\n", shell_output("#{bin}/ts-node test.ts")
  end
end
