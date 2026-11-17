class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.16.7.tar.gz"
  sha256 "c2b560ce5c241650416c525e2e57f61686a0f33569802d84bd714e68fd646122"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9092ad45612755686517a4156db5669ed65e88ce8009fa547c88453009b99f59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9092ad45612755686517a4156db5669ed65e88ce8009fa547c88453009b99f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9092ad45612755686517a4156db5669ed65e88ce8009fa547c88453009b99f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d43007a862fd6160f97d27f8103bf6dfc060cb825071281a3be0ecde71e6c4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "81ec00284ddd2ae1a0392b3faa63e8d1f68b5b20f578c063cbc9a549beca9bec"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  # `test do` block queries GitHub releases
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X main.version=#{version}"
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
