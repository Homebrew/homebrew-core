class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.12.2.tar.gz"
  sha256 "f95bc6a76dddc359e4ad059bdd53c5442000b8fe445d88ee45724fb3ff57ee33"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b713ee5113fbf6621dbc494b8aea2c5adca8fc9625733e07027af0659a4b88c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b713ee5113fbf6621dbc494b8aea2c5adca8fc9625733e07027af0659a4b88c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b713ee5113fbf6621dbc494b8aea2c5adca8fc9625733e07027af0659a4b88c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "997b7392776c086b0e1abb293a59afd5d0f62eda6dda4ad22d6ac7b92dd14c0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77b53be4eaf7c2a4471e6675f0830d7f1cc11da7b69f2281f03efe40b77963fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad748396d0784ece8574ae703c51516474bacaf75cb2509da550b2d78c233da"
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
