class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.14.8.tar.gz"
  sha256 "41094ae845744e9db572875415f8fbcffa8d335491f96567fa998dca36487f9d"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9a1b8dd4cb987e274abedb8148939d4ddf74fc451d6331adb2c395b570204b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc9a1b8dd4cb987e274abedb8148939d4ddf74fc451d6331adb2c395b570204b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc9a1b8dd4cb987e274abedb8148939d4ddf74fc451d6331adb2c395b570204b"
    sha256 cellar: :any_skip_relocation, sonoma:        "809ff42447f52302e6364103ea0fe985ea4955aef505922236035d8f8095293a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34fc7f700f8b56b84ad25d4e75a524444ab51b9ae34af055bf817e21cce63417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc8852c54b59ee2cfae3302fc949e85ae86e4cc8b289b1d2748cc27d9996519"
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
