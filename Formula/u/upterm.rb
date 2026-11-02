class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "124a24a665b3707289e2b2b9f6e2df26ca14b13d87b3d9c2a114524ea2831a77"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e53439fa5171ca55239e8683fd76e6b35cf2272179d659ac7bd0b5d332122167"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9989804be88d04cfd137c93bece730ea28c37fb8c0f75ee849a2fdf5aa546f6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22622463bcd0867160a64266a401cf650a0327d7708a0500e40ccec963b89ec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5eb438a3b671238e971fd2a3b070cd6c3ca189cc9cfc00fb2e6787d509fcaf3"
    sha256 cellar: :any,                 x86_64_linux:      "329afca255a5a8e014256a5c91ece4a6a33479f3b39d6b5ceec3c69f54ce51da"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/owenthereal/upterm/internal/version.Version=#{version}
      -X github.com/owenthereal/upterm/internal/version.Date=#{time.iso8601}
    ]

    %w[upterm uptermd].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags:), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upterm version")
    assert_match version.to_s, shell_output("#{bin}/uptermd version")

    output = shell_output("#{bin}/upterm config view")
    assert_match "# Upterm Configuration File", output
    assert_match "server: ssh://uptermd.upterm.dev:22", output
  end
end
