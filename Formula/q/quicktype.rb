require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.76.tgz"
  sha256 "00cbdb63d80196669ae7fddfa17a1ad39a69db32566a92d558ea92ff6d16b821"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e16bf0a4bef00d435af28ee4172b3e4b84289684e69e39946c2186aab6eb959"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e16bf0a4bef00d435af28ee4172b3e4b84289684e69e39946c2186aab6eb959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e16bf0a4bef00d435af28ee4172b3e4b84289684e69e39946c2186aab6eb959"
    sha256 cellar: :any_skip_relocation, sonoma:         "96e7edb41408254c774ffb3ae3725b8cbdc6c256d1752febebc53afbb1548ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "96e7edb41408254c774ffb3ae3725b8cbdc6c256d1752febebc53afbb1548ac2"
    sha256 cellar: :any_skip_relocation, monterey:       "96e7edb41408254c774ffb3ae3725b8cbdc6c256d1752febebc53afbb1548ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e16bf0a4bef00d435af28ee4172b3e4b84289684e69e39946c2186aab6eb959"
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
