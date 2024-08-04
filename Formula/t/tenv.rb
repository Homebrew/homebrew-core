class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "b05ef683581dadb9f780f19d915b5f85017b3c95f9da699cf916d54a0a06c146"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0c2e1e9c82bb9a252de6286b7c2b819256673a2847a84903b6c48138fd50620"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0c2e1e9c82bb9a252de6286b7c2b819256673a2847a84903b6c48138fd50620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0c2e1e9c82bb9a252de6286b7c2b819256673a2847a84903b6c48138fd50620"
    sha256 cellar: :any_skip_relocation, sonoma:         "73b4bd46a2bfb9aaa38c7efaa78cf407ff3fd5b77a8f4d048f3b898f606e5876"
    sha256 cellar: :any_skip_relocation, ventura:        "73b4bd46a2bfb9aaa38c7efaa78cf407ff3fd5b77a8f4d048f3b898f606e5876"
    sha256 cellar: :any_skip_relocation, monterey:       "73b4bd46a2bfb9aaa38c7efaa78cf407ff3fd5b77a8f4d048f3b898f606e5876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bc9474763fa67c9995a131697bcb2b72f0c6ec5f395f2bd9e0877eda77fee82"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
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
