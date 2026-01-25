class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.9.1.tar.gz"
  sha256 "fb2cb343857f6a668279d31d22998c2cf54a8af8d54c541334ccefa78105a63d"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c1d6488e22f62b5ddc589f454b0525ecd1bc7c1b72534d74c7b85e6ce8d0f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c1d6488e22f62b5ddc589f454b0525ecd1bc7c1b72534d74c7b85e6ce8d0f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c1d6488e22f62b5ddc589f454b0525ecd1bc7c1b72534d74c7b85e6ce8d0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c237bd1a62abd8b74dd54fe63ae20bb14f70b4789b1e09357da080288ef13ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def8a51cc120c2410bc0c5483a16d00b29437d0aafae95205af0806fadb033f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44e89f60731c394caa106f1c46e2750d17835f17d7b97499f68d01d3348b7a7"
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
