require "language/node"

class TsNode < Formula
  desc "TypeScript execution and REPL for node.js"
  homepage "https://github.com/TypeStrong/ts-node"
  url "https://registry.npmjs.org/ts-node/ts-node-8.0.2.tgz"
  sha256 "ba6a690ddf1e441425fe47d37b06e61fe4a8d3be10430b17eb286630d9569324"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Adding typescript to library's libexec
    # https://www.rubydoc.info/github/Homebrew/brew/Language%2FNode.std_npm_install_args
    system "npm", "install", "-ddd", "--global", "--prefix=#{libexec}", "typescript"
  end

  test do
    (testpath/"test.ts").write <<~EOS
      function sayHello(person: string) {
          return 'Hello, ' + person;
      }
      const user = 'World';
      console.log(sayHello(user));
    EOS
    assert_equal "Hello, World", shell_output("#{bin}/ts-node", "test.ts")    
  end
end
