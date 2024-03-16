class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "e67f51f30bdf38cb8140f781181412258b0096b36fc4cb0a270aa5d8b7956c62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bd5a03c915bfaf0631bcb090acc77f557bd2997481f03c8bb002acb96b888f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ebaa55c909f3e7df9d840a9e0fb7afda5c46ba07e8287c0a8a5904f2701ef5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5211dd22533970c0a8bca9ee7e1bfd6ca72dcdfa5c82cc1219e8ee5ee66ac6e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dc1a4f51bbe75f4fc9e5ee4dea8e7c4c3c7cf712787b27b2cacfb983526429f"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c87ad965ae1cf99e9b2882248c7aa2fd5ae2ef9725dfbbde6a6c8cd0629f73"
    sha256 cellar: :any_skip_relocation, monterey:       "996d45bb577867d82dd381aadd83f4b4b5d03608713bd0c83b7ef31ca438f63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8090fda72f86ee286abcd8ef69f535ad7c58f4eb7c02e96bed8b8dd5a5561500"
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
