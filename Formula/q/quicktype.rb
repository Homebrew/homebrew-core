class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.170.tgz"
  sha256 "659d134a323644b799149dc562882092544804d69a5288574af4d657f3c00a57"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a0165ecdfca165b21db3bf3ea97076058bd2a2b58d822ea665532030f69359c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e197f59d0b6c2e62f03322b0e4f014671c657515a16d3bdac7ae1da3369ba16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e197f59d0b6c2e62f03322b0e4f014671c657515a16d3bdac7ae1da3369ba16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e197f59d0b6c2e62f03322b0e4f014671c657515a16d3bdac7ae1da3369ba16"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e037edc65fcbe0cd256eef1142fe93ed25cf604af3a5ec9432f9a2381e6f614"
    sha256 cellar: :any_skip_relocation, ventura:        "4e037edc65fcbe0cd256eef1142fe93ed25cf604af3a5ec9432f9a2381e6f614"
    sha256 cellar: :any_skip_relocation, monterey:       "4e037edc65fcbe0cd256eef1142fe93ed25cf604af3a5ec9432f9a2381e6f614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a741aad8272c2f841c25a8ce5a919843e84006dfd224eba6395ffbb9f22319f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
