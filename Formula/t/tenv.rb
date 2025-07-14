class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.7.6.tar.gz"
  sha256 "006233f57c84f10d33716ffb192326c45460475de9bde6ea81acae1d42e8654b"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "752a4df1d58c88788c9b699b6e94e32dc70b14b982dd77fcb0a7ab24c86c803f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "752a4df1d58c88788c9b699b6e94e32dc70b14b982dd77fcb0a7ab24c86c803f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "752a4df1d58c88788c9b699b6e94e32dc70b14b982dd77fcb0a7ab24c86c803f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e3894c1e7d72e0533925c969de733619c393ef90ae278ab5f73f4c6d6f2ad6e"
    sha256 cellar: :any_skip_relocation, ventura:       "4e3894c1e7d72e0533925c969de733619c393ef90ae278ab5f73f4c6d6f2ad6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7845250cbeac9b570a6f5d02cc954bff0c97d23d50979d282409dde377e3833b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cfaab99d16ea83c4174600417d09d2bb7e1561b165a975419ec77c8c79cb913"
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
