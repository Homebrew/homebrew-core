class Trdsql < Formula
  desc "CLI tool that can execute SQL queries on CSV, LTSV, JSON, YAML and TBLN"
  homepage "https://github.com/noborus/trdsql"
  url "https://github.com/noborus/trdsql/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "58a4b5987e80ed313bf878b070b4d94768fae658f2cf56f353284d762937a84a"
  license "MIT"
  head "https://github.com/noborus/trdsql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a36be03abad1308d14daf19945a9f3c38fa012124105caec8a1021f2db73f84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983749de62078d684a988c2f21a0075ee1343373f0bbda3e271f6900492b749f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da216f2410476f2e44eaf333bc0b2b3e1be06b1e8af19a5cb0ba7f96169b8702"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9d2cdb717612a4abbe4b0827d23d8c3b1dbe6f0cc72f5f3828ef65cc779e365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3cc6d52134fbf901bdd5d930b7f483f055e0f0c34ebd3213bde389f4f63d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00bfda8aaa8de57509af6cdf77d5b486859bd928ea10c569051bf3f04b3545c"
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
