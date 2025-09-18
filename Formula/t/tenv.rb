class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.7.21.tar.gz"
  sha256 "e320d79495cc15f22386f7b305bb4915fbb5d349e8b6d5713ca1750266cb1275"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d16ed18031c65fdc3abcdb0076c45406104b1c0fc97855fa481c45c2a0e59bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b96df51a328414e2ad5d4bb8f95cb94953dadbb516c456ef940e8a6cda6740ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b96df51a328414e2ad5d4bb8f95cb94953dadbb516c456ef940e8a6cda6740ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b96df51a328414e2ad5d4bb8f95cb94953dadbb516c456ef940e8a6cda6740ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "2616b23ade2f41d21afe865395ee15a6a0cb7ee6b2c18c746acf53c1a839f1d8"
    sha256 cellar: :any_skip_relocation, ventura:       "2616b23ade2f41d21afe865395ee15a6a0cb7ee6b2c18c746acf53c1a839f1d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a920766536256b783fadfbca3f082cf16dea68ce3c8e99d6614f36600649c50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f919fde0fed92f5dbe82686d97ee1db952003915936ae77411449285a59d8da9"
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
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
