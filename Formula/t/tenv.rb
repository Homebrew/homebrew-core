class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.11.1.tar.gz"
  sha256 "f78771feff879fadf7ee4a72489230111578f44e11541607787cf4211e7ee538"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8761c392f8f44a944cf81074db416e73432275b51f61d77c76b271020c722697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8761c392f8f44a944cf81074db416e73432275b51f61d77c76b271020c722697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8761c392f8f44a944cf81074db416e73432275b51f61d77c76b271020c722697"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b5d5c7121736904618bbb0e7763eac47f8f23803a064b873640e967bb435e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b409957a36af9b9833f0f22a60944234895b85667aa7fba497a919a344816261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291cbcc0443adf804cafb43dd27be205a6309b9e18a109c3a9b01dfacf896ee6"
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
