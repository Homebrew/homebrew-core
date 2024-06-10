class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "f98cc41c6e6e009ed3211660087e06875ce46c8d12126a8a916dfb1a8c8cc66c"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e10a28b5f46f2dd7bcfca4093059a7d7f630343917f90e8d21588d30dd842ea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e10a28b5f46f2dd7bcfca4093059a7d7f630343917f90e8d21588d30dd842ea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e10a28b5f46f2dd7bcfca4093059a7d7f630343917f90e8d21588d30dd842ea9"
    sha256 cellar: :any_skip_relocation, sonoma:         "46af825d876286a15a548a27c4181bbb795b9d6a872b5703a27ef43a736653f8"
    sha256 cellar: :any_skip_relocation, ventura:        "46af825d876286a15a548a27c4181bbb795b9d6a872b5703a27ef43a736653f8"
    sha256 cellar: :any_skip_relocation, monterey:       "46af825d876286a15a548a27c4181bbb795b9d6a872b5703a27ef43a736653f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b437b84899e66336880bd30e2cbccbc8ff3c7cf0cf792c0ed32e23774be8d335"
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
