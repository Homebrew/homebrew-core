require "language/node"
require "json"

class TsNode < Formula
  desc "TypeScript execution and REPL for node.js"
  homepage "https://github.com/TypeStrong/ts-node"
  url "https://registry.npmjs.org/ts-node/ts-node-8.0.2.tgz"
  sha256 "ba6a690ddf1e441425fe47d37b06e61fe4a8d3be10430b17eb286630d9569324"

  depends_on "node"

  resource "typescript" do
    url "https://registry.npmjs.org/typescript/-/typescript-3.3.1.tgz"
    sha256 "5693094bc766af02ec381114cb933c1f6ffc78c1395a4c42b55b3ccf48aa4f50"
  end

  def install
    (buildpath/"node_modules/typescript").install resource("typescript")

    # declare typescript as a bundledDependency of ts-node
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["typescript"] = resource("typescript").version
    pkg_json["bundledDependencies"] = ["typescript"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"ts-node").write_env_script libexec/"bin/ts-node", :NODE_PATH => libexec/"lib/node_modules/ts-node/node_modules/"
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
