class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.8.11.tar.gz"
  sha256 "5839211c84ccadaa117652ec8b7de465809475cc6825ab5bbd6672284648a035"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcfe15f7ea4e43cb8a2d532d998167c1d96bd9b375e599c7f074b1a0cdb0639a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa8570aecf022931e1e05c608e3d696c3b526254a0b1c836328e5c6e3320ce8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6858138285b4889680b0d7a9ade6edc897dc553e88268ffd3d985e5595cc605"
    sha256 cellar: :any_skip_relocation, sonoma:        "b391d0e4c64e267f5baab1030c2eaa0bba1fe8642fc07e61d9da732668b297d9"
    sha256 cellar: :any_skip_relocation, ventura:       "aabf7721967e28c6fe8cb8d6ec8f845dbb24d10e6ea9cc463b3b77c2f97db57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72de35f938e60a99fe2da0bf998f049b3744c9a126f7ed25967cfb74c176eaa7"
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
