class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "9e6a9f8aac198f90e2105689ecc28f3c043ded6677ec90c7141ed4412993863c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18613f9dee4dde72b22b7855ee6e8799f2327753ec83560f3fd54dd23ec44605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065dd411cf866e378a4d1f82f2c75363758472cf9c26ca7d846f839eb50bae5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd538195feb6d190a4362a787212fda337de8da3642c5ec09b323d9774892ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8525b0c9f29dbdf601b1539ce7bdcd9496ceb3c215c8ded715139dc5c3761799"
    sha256 cellar: :any_skip_relocation, ventura:       "53e457c1f5d73347e3d07d60b71947f3cc718c2caa5a4e3ad2020c3031667d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523bd7caa8456698a19f08f77d6d52f3a8d5b50f54b3b7e18de87c65552fe18d"
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
