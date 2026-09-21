class Upterm < Formula
  desc "Instant terminal sharing"
  homepage "https://upterm.dev"
  url "https://github.com/owenthereal/upterm/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "43056b14ea37ed3762664b1abc8b5c3d22f47dd5155d1501eee07f30bc3a2236"
  license "Apache-2.0"
  head "https://github.com/owenthereal/upterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fce51782ef503fe555fa9d816c3642abb0debf02d620abaf45679861eb8a199d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b0ef9acda0bf6b9b945896b52b05cb8c6d47455acc1b0bccec4471b92d70a08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4591670ed1a883e4af616aa96fc026aeeb34173967c9dec9b684fea64a52af7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca86f3cf72fcc7028220aba3a2b34f0ac3d5ca54c96a314d76fdbe74d77005ba"
    sha256 cellar: :any,                 x86_64_linux:      "ade8ea2613e58a6573e8bb571411f0c3a8bb01e4b83d082fff13fcc06be10b59"
  end

  depends_on "go" => :build

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
