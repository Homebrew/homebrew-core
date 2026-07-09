class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "94d43fe61c111c8e54bb92ee1c3f49b70df335cc82b42f94d5552f4fb1f78294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "659c2e3ef48fd7a5fe9ca4ce3ecaed7fea7850736775a85022f3d84714f3b753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659c2e3ef48fd7a5fe9ca4ce3ecaed7fea7850736775a85022f3d84714f3b753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659c2e3ef48fd7a5fe9ca4ce3ecaed7fea7850736775a85022f3d84714f3b753"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc70aa2dc1cff197237b3bb522eea78eb58757e6e915d90d925a5cb5844255fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c649a1be4fb30aeab9dd6b09e2dae2ce3cacfdc358befa2f4792d3e8da7a84ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b173cc152421d8aa5015adda5e467b38e00a23e2c3f0a13977a1330eb825512e"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gost")

    generate_completions_from_executable(bin/"gost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
