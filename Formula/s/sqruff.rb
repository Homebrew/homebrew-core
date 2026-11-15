class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "24345a86b4b5ec5f312f8951071f75d1b0b918077bfe23fa21642034abd8641d"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "572b0a437663e0862672efb6c624a342a62b74113784f973afe2b39c70f70aad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db9eebe4dd421cca72b0057ff65176b817013ef4856437f43a0dce80fa219d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba33d7216504ea0f59ac419f8499584463eb22ee0d6a2f3a01691435de5c74ea"
    sha256 cellar: :any,                 arm64_linux:       "d5d05d974078bdb5508a0bf13e6acf83f906b97e80c30ca481d44e854acee4ae"
    sha256 cellar: :any,                 x86_64_linux:      "84f06721d3ceb28d77ed2c3d6a95cf2726e9b5ae62c1d37601bb7c0ca071354d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    SQL

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end
