class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "4ec009b0da3d1645d7ebd674b7f36ac92831946e8d5fff812c352fab041c1d39"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095ede69e3d74d32267576839572e168f9b9c98489bdc4ae6f69c3902afeaea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095ede69e3d74d32267576839572e168f9b9c98489bdc4ae6f69c3902afeaea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "095ede69e3d74d32267576839572e168f9b9c98489bdc4ae6f69c3902afeaea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2511e98d81309fc37be0304b54cfc44d9c1b7bcca08015cbea0539a7df55b45c"
    sha256 cellar: :any_skip_relocation, ventura:       "2511e98d81309fc37be0304b54cfc44d9c1b7bcca08015cbea0539a7df55b45c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8cba15f2557329865c7d849f741829e260b2a00cc9c695841888689be2bf539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4295099b88e34e39a1ced6dc712ac6e2851492a885e533735e5f3547fc6638c0"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
