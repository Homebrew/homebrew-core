require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.2.3.tgz"
  sha256 "cf58ef57a8b173fad9f81969d3995299e40c770a02805117520b4c75d43ff14a"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "290b74c94434f7e71c8033c7a9ef3a5e49db74ec2f35edc667320a4cb3aa7a47"
    sha256 cellar: :any_skip_relocation, big_sur:       "078b4cb670e85250dc836613944d1e9a683b11ad9ef3af12919d673c7bf73174"
    sha256 cellar: :any_skip_relocation, catalina:      "707eea072f0475ecf05dd914793373a95ca313732b3ef78327c728f94f8cabc6"
    sha256 cellar: :any_skip_relocation, mojave:        "5b017e91762fbfe6a50749f3a10ad7f268dde78f8e1365d6a83ce1fc0f5d22bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
