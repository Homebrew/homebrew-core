class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.9.3.tar.gz"
  sha256 "ab24c11bb42f580d8700b357b7e07fdb004fafa6133f8ebd0e9d50829f66face"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e335f46b686ce3c59fd85248a6d950d5fee8a6598446ff7dcfc8e48f0919d0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e335f46b686ce3c59fd85248a6d950d5fee8a6598446ff7dcfc8e48f0919d0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e335f46b686ce3c59fd85248a6d950d5fee8a6598446ff7dcfc8e48f0919d0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfd150e9a204cc8e1d42e52ca36a6cc6eb2693d4e535bd549d7350aec37d4473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16b34b883c014fc21abab81099880555a5ac6a80d556337f4f8f1ad9b3b22b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee1a8cea536a796b844d22f1bb85b70c3f065227f28b854029f719d6a9cb5b74"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
