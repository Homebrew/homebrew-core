class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "d1b91cd1e52fce371a42c2a3c12ee2cf2b629205a23af8bdba8ed9d3814c83ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d8eba2a9d00f5f2e2aafd9a9e52f46a41d47e9d4afa08624da85fbca940602f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399845c2f1cb948a4c2026fc29036ef077f0f1ec7298b7639fce6a5b5a6d168a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a42fe337997b83802e10a6665770b63c25f00ae7193c5f184c6fd5a523f34b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e63efd450c83e6f26af1eae5ac9c496302f4b3ae2b7e7967815f7f315b13dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "01e01536679469e7502067b93b91d47baddbe746710371d0dfef82a659c167d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c88f649b4d170a23ed43edfbd7d865463a6089d3a87d15ee334ce9d47a089103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5fbbae841c9a0d8ca98d8b6cfbb1960f0eb5bcb9e6a2202d5b0eaf984b6cd8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
