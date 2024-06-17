require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-8.1.2.tgz"
  sha256 "61efb50980cec578f752336c4f930e5c7cefc7a50a24fe3a113c5f276ec0d1ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ed47a242327eaae55b85a1606fa40adf3de989bfd8f79908091f5cad5117e83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ed47a242327eaae55b85a1606fa40adf3de989bfd8f79908091f5cad5117e83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed47a242327eaae55b85a1606fa40adf3de989bfd8f79908091f5cad5117e83"
    sha256 cellar: :any_skip_relocation, sonoma:         "6673e326e7f262b58f9bf8e984393c94127e1d157d394c076096dd28470d48ec"
    sha256 cellar: :any_skip_relocation, ventura:        "6673e326e7f262b58f9bf8e984393c94127e1d157d394c076096dd28470d48ec"
    sha256 cellar: :any_skip_relocation, monterey:       "6673e326e7f262b58f9bf8e984393c94127e1d157d394c076096dd28470d48ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e59666cdb351dc5c2c8c34484134db620519b198933dd6b4120d7d544c4f4211"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
