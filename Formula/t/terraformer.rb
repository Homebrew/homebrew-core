class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/refs/tags/0.8.30.tar.gz"
  sha256 "9e4738fadae011e458fa6fee168f47166cd3a9f5d7a9378018116345b0d6b4e6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77df38f3f9fb70c3e797b0383a7806f4b4eb48e6d3966a228b2ae28094f47b75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76897a56f9ca4e794bfda1657619693478002f030986002ae0488f375f24eaba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8075775bc33c531995a7ab2e7b3f064f7e0bf437481959d48a9c57a85c40c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbe623acb962e6d9b1e76120231ed2de80de73a57e0ec938f5671e692ad1d587"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2af0e4b871f67d1c732e7cae619a59624f22e3ba6f5adb8afa45d2a6e187dee"
    sha256 cellar: :any_skip_relocation, ventura:       "78eacf84bec4f443c67df8e8cff13534af27ed4beeb3692bc78e59c6adaf6a67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa13f910e96e23576a6b03ba649e12a684bdfc1222246ea0c5acb4723b37eede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdfe4cd7d86eb95d6c0a08849778d3c0813ccbf2ac6b7dc2face163688ad01e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[-s -w]
    # Work around failure: ld: B/BL out of range -162045188 (max +/-128MB)
    ldflags << "-extldflags=-ld_classic" if DevelopmentTools.clang_build_version == 1500 && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
