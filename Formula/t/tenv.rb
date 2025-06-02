class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "f3ebd348301163509d23c0cb6963c6f69bc9b942c54188c09605cd63f08475a0"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4979db9217a1754ec4a42a5242a7ad8548d47eef60885551c50de8c5c7a2851b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4979db9217a1754ec4a42a5242a7ad8548d47eef60885551c50de8c5c7a2851b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4979db9217a1754ec4a42a5242a7ad8548d47eef60885551c50de8c5c7a2851b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf32d9d7e7083c7aaa6f765f5b5209af8920720ee9d4970300a0cf719cf36ac"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf32d9d7e7083c7aaa6f765f5b5209af8920720ee9d4970300a0cf719cf36ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119d4999e5653c0fb3908518b44ff310498fc8846e783a6a003735feecbaf490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc81e559643d113da84a932b8ec3788541bbe5474586cadef2b08ba670d95217"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
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
