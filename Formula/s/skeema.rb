class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "d072315fbb941555b6c009d99ca2079950e5a18d9dffce80f54d4ddc6cc23c44"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d2ddd22b895287001d3c49ea23b86275dcb9d5cee9a5762c3e4cedbe1832ea8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d2ddd22b895287001d3c49ea23b86275dcb9d5cee9a5762c3e4cedbe1832ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d2ddd22b895287001d3c49ea23b86275dcb9d5cee9a5762c3e4cedbe1832ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "445fdd7e72ad07d24dba2ffc7242c003959b2aa04c43fe4ed13a699f49e83815"
    sha256 cellar: :any,                 x86_64_linux:      "fa2500a2303c441e9bb72a507e08483dc35a31ae7b29d2d36940ca52d1a3089f"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
