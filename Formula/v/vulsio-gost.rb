class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "106b40bd3061f5f8267497fc387d5ffaba9507a48378cf827c49e88c00142b19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a79a4969978031258e93980fe2da672e04d95f6c0b1faa23bb21dd58f7ce163d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a79a4969978031258e93980fe2da672e04d95f6c0b1faa23bb21dd58f7ce163d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a79a4969978031258e93980fe2da672e04d95f6c0b1faa23bb21dd58f7ce163d"
    sha256 cellar: :any_skip_relocation, sonoma:        "763d57082d74e19b850975d4759d4ed07d7fe8c9df22c3253125819a458d2d17"
    sha256 cellar: :any_skip_relocation, ventura:       "763d57082d74e19b850975d4759d4ed07d7fe8c9df22c3253125819a458d2d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7f3559d2c176bbc05c9a02c1e4f22e6c5cbcee92ac7317260bbc36fe17af5e"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"gost", ldflags:)

    generate_completions_from_executable(bin/"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
