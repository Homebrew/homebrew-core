class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "34421357447ede968a6875d38858c252e987a94aaa5f56ad6e14a17e51ee15b5"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd06050877b0ea91b5793cfe869e9f1dc4272658fa168133432bc36335a0c560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb5ef33491450375cc1904be3f3f4e5d7e38417d6542ce2daad19ba1d1cea90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415089521b878ca2839c3d3a567241ea0bac985a2e97e48a6fea430c6ba4f611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bb99c142e24f1834e99a45777395dbb414005ec208e298ad706b7aa9da283e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "70584e191d36fbfbad968a5fe7f042dc43ed910049eb3f29a8c362ecce9a8730"
    sha256 cellar: :any_skip_relocation, ventura:       "8943927f1d88712457f46887e8d3b045d45def37b824b11c03d992d555340d80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97828b7090733d2e9cc43a61f61571daaf4e2d96d38d0af4a0faf9195ea5fdbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bdcb8334c6f968f3bc3ecf8dc17c3c58456403daab5c9fb8e67ab2f35957451"
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
