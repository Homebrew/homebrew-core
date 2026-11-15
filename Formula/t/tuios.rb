class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "60c7fb5221750f6f736e66709f9deb7249fa4b29e83122782cd80a2a1a17a60f"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a11481446b8728eb2d16f0a4c4e8652961de501d042f35b01a0ba6a24420fbfc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5456ceb2d39a8ecec7626f3e621569b5ee3a75904c8a4e2bec9213f4a427d79e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "092baa244b099bfe3cb9327f7629b496b7935eff5b154ac5224cc4a14a666953"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f43f73ef775e22c62d62d68b3c5cfbe255293372565d2f698f88eb8c3a3c187"
    sha256 cellar: :any,                 x86_64_linux:      "55161dfefc7e35721f01545cb3bfb7b9c9a7ea1d570feff3638059354d24ad5c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
