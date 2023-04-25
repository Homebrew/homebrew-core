require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.21.tgz"
  sha256 "a19fdcb9f4328566db3debb2428ad8eb98418c7880798b84f9c38046e4b88ba3"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6805d1ce68a8d66c4c6e64175eaf399da4d9ccfebefb6455d94b92483a0620c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6805d1ce68a8d66c4c6e64175eaf399da4d9ccfebefb6455d94b92483a0620c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6805d1ce68a8d66c4c6e64175eaf399da4d9ccfebefb6455d94b92483a0620c8"
    sha256 cellar: :any_skip_relocation, ventura:        "83960a2fddc942e3642f21bc941a4e25c790c182ce9be5e53805c5e2a4bbe61a"
    sha256 cellar: :any_skip_relocation, monterey:       "83960a2fddc942e3642f21bc941a4e25c790c182ce9be5e53805c5e2a4bbe61a"
    sha256 cellar: :any_skip_relocation, big_sur:        "83960a2fddc942e3642f21bc941a4e25c790c182ce9be5e53805c5e2a4bbe61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6805d1ce68a8d66c4c6e64175eaf399da4d9ccfebefb6455d94b92483a0620c8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
