class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "49538903f16bd08bfa24ff4b1bfb16c0edf93eebd730e072425200a4b21faed1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbe2d32725e8c1126441e7fc0745322c379a7d5a8842232e69bc02c2ff462442"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d50d42301674bbfffef5c7f8de4eeee0792326ffa70ba8c827579c5cda5e38be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4983c3484d38e6fb737ded66f76bae3412da1404ed3e163e80d01a056fd68714"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca2d34fe535418d91710b45e00587156c6439afa3beec6045c6adea661734f04"
    sha256 cellar: :any,                 x86_64_linux:      "6becd918f58759307382b335eb8f19713339fd21eaa7c58c636c678bbe065ddc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", shell_parameter_format: :cobra)
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    event = '{"process_exec":{"process":{"binary":"/usr/bin/foo","arguments":"bar"}}}'
    assert_match "/usr/bin/foo bar", pipe_output("#{bin}/tetra getevents -o compact", event)
  end
end
