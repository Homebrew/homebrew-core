class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/glideapps/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.175.tgz"
  sha256 "4333dfb188e06bbec8243afe78a55c256e22aabb3e4ed97d3b5c5272bff8ad17"
  license "Apache-2.0"
  head "https://github.com/glideapps/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9daafe9da067b31378a0cf0f3d3ab1e50f4d2ac988c0d5e7136c07427e31e84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9daafe9da067b31378a0cf0f3d3ab1e50f4d2ac988c0d5e7136c07427e31e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9daafe9da067b31378a0cf0f3d3ab1e50f4d2ac988c0d5e7136c07427e31e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "3caa006fdadbcae74388228ed8fff39d8f08453fff874bd3b4c8773560c048f4"
    sha256 cellar: :any_skip_relocation, ventura:       "3caa006fdadbcae74388228ed8fff39d8f08453fff874bd3b4c8773560c048f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9daafe9da067b31378a0cf0f3d3ab1e50f4d2ac988c0d5e7136c07427e31e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9daafe9da067b31378a0cf0f3d3ab1e50f4d2ac988c0d5e7136c07427e31e84"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
