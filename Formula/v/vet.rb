class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.14.tar.gz"
  sha256 "a842e468b7a1810e79e4d34f6e7a2efe0f2b423e0c6fd22c0713124dc0199aeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a1518405ee14b66c2e10e0022663cb760571982776efc092585ef14b3f24731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a7c378618cdb6d50b6ede095ca45010e0c965cf37cbcd7c2d54e369b21f8bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "416604f81537a192c865205a59b658d489403120900324aaf0d2c929a709bcb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b3d4e69a25ad6183f477c917bd2b79df2e5fd540adf5b57b23742fc974f504f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bdae73693f2aae072b758e4810d113eb64f48f9bd48e6eb559da0d0128d91d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f639bb445c4ea147edde74d33803ec4359f4f1d9d16b1af3b79222167c8748"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
