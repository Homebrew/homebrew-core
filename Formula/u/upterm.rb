class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "124a24a665b3707289e2b2b9f6e2df26ca14b13d87b3d9c2a114524ea2831a77"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a8ca16068945b712bac5d64be2ab04afb10837a6a34f97b9b0f5efeec4c4a9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb3467ec21122b801b5df1926ce399b77314553786c88ed3581ed0a89cacf9c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9046029e2ad979d620b4e9c851cd2966993c0b61da96e729a24e54675188e32c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fea7e4d9c69831056fc359b69163911a59af0460f7cc31a28cd34f7888bf1737"
    sha256 cellar: :any,                 x86_64_linux:      "6a3bbffd61521df0e9243d2acbef93cef26a0e17797e73e3be925c0d7f0969d9"
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
