class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "6a409100a292bb03b5c891c9ed42de39cc72f6dfcc788138e6b51f3b58c22241"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed16860c96e33fc6b2c9cad858d6986b924c316a01bfc5d1ecdaac8b5ec6b589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958e0e2c5c18ff25252b437c2af241331a3803aab7ecf4e33986038865e908d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f79792b438dbc25f3b851a6c2c5538b5978893cdf8cd7644af8106aa9ea19cd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "05bb35786415fd019a9a97ca4303aa4d3d401a335b61fb5c7785d8baa7c4947b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b052176a4021cb95ce9aeb335252f2da78afd9b71968035bc39b10b073e5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aae44016f8822a037c47efbbaa85e9c9f62444d0bc18e1af1c0daae95d36465"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end
