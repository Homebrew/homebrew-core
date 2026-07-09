class Trdsql < Formula
  desc "CLI tool that can execute SQL queries on CSV, LTSV, JSON, YAML and TBLN"
  homepage "https://noborus.github.io/trdsql/"
  url "https://github.com/noborus/trdsql/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "23a80d1c7cf44f458440ad9b6ffc5dc9305e98f191fbce102f47bf6be2c4fb17"
  license "MIT"
  head "https://github.com/noborus/trdsql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268e31cc727f5055600192d83c3b4ca00bf38c89e2550afdb69862928db6b6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33f040dc8f9911b618184533319b1b651dd8cbb175762d81ecc3f01d471fe68f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93bbe7dd869d467a2e9342d2a5e5c8d9cc62d40e05c36be4261510c4df6c6b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf71f1dca12dae6f7d038f5732095a3a4c74e318b6aa7dace2618dc064bb93cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4fbfc43e89d765b828025d06b031fdec75b3c81492eb1e1fe8b65ad9af60a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d45f3e36af3a0c9268046776b09bc09bcfb820ada2aeb3fd8416dcf74ce1ff0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/noborus/trdsql.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/trdsql"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trdsql --version")

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
    CSV

    output = shell_output("#{bin}/trdsql -ih 'SELECT name FROM test.csv where age > 25'")
    assert_equal "Alice", output.chomp
  end
end
