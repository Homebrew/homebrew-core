require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.170.tgz"
  sha256 "659d134a323644b799149dc562882092544804d69a5288574af4d657f3c00a57"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3835e6f164868aaec4537e04dd0aa46fa94c4b8167f73fb6bf0bcae2c25f9a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3835e6f164868aaec4537e04dd0aa46fa94c4b8167f73fb6bf0bcae2c25f9a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3835e6f164868aaec4537e04dd0aa46fa94c4b8167f73fb6bf0bcae2c25f9a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9272e6f82df99189c7487df54b134f7649424e283eebc95857eed36a06d9a5e7"
    sha256 cellar: :any_skip_relocation, ventura:        "9272e6f82df99189c7487df54b134f7649424e283eebc95857eed36a06d9a5e7"
    sha256 cellar: :any_skip_relocation, monterey:       "9272e6f82df99189c7487df54b134f7649424e283eebc95857eed36a06d9a5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a57d6a5aee7eed9ed6840c933d1d5359d8921e44c0afce217cf88dd6e025b61"
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
