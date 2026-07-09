class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "931a88df4a86502822fd315587dcb7527aa4a1c67ed6f97b00698f33fd5a51a2"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "517d968e13195402ab6773567f3a68ad1fb8a38cff2c583a036d5133ecb8bb97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "517d968e13195402ab6773567f3a68ad1fb8a38cff2c583a036d5133ecb8bb97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "517d968e13195402ab6773567f3a68ad1fb8a38cff2c583a036d5133ecb8bb97"
    sha256 cellar: :any_skip_relocation, sonoma:        "91ce2a9a974ca0a70cb8c01b71001cea49ab11ef8cdfd17e53db268ec0071025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12a60b78c156a88250b400a935b2b36e9d0717fd3a7e060f868b6e11c4663d62"
    sha256 cellar: :any,                 x86_64_linux:  "0ac47ae55b6cb947e4f3a4fe7fd7a96d67377736a475b99384d86c507e028c4d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
