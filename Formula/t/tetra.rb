class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ccccbe870b880212a86f959ce6f3f9f2d378646ad314100862ea6db5cb5f0a2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29aa4d37b1ff8bdd54b6a4039dd292db75b79695565d2cc4ecccf70f89074b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d872433dac34a4357359cc8d49a15e2327846cbbecc247bac98d7e11a7c6d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de806a15af6d8b30163988588f8dffaa44f0f6f9a2714c7a29fe858b822419f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "924b2013ada6d0742ae86b7d4b608d6d3113812579b5a78a02fe5372ba5a0dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d831fbea91449d536d6b98576640831d9fea9d63893e23028b070da1bd09ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e1a3632043b8a745a4d9ab97615a5454b45955fb98f043427d1737600ac43f"
  end

  depends_on "go" => :build

  # Add missing darwin stub for bpfProbes function, upstream pr ref, https://github.com/cilium/tetragon/pull/4933
  patch do
    url "https://github.com/cilium/tetragon/commit/c99f6bc0b8bebb40cf3cdaf1216e62c8717d85cc.patch?full_index=1"
    sha256 "1a09f1f9324394a117a3f09a995ef56a5d7d4633169b9a8fe103425fabc840f3"
  end

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", shell_parameter_format: :cobra)
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
