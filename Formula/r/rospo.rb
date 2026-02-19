class Rospo < Formula
  desc "Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "4c36291969c84159baff261841e6ccd9520e17f8bc9142bf815b9097322a8857"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43494ada262f259f82c05219386a821a57d24053dc7d17f5bf0466509c2a529a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43494ada262f259f82c05219386a821a57d24053dc7d17f5bf0466509c2a529a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43494ada262f259f82c05219386a821a57d24053dc7d17f5bf0466509c2a529a"
    sha256 cellar: :any_skip_relocation, sonoma:        "19405ba3bdc6ee02655fa1ab3eb9b89aedeb4459792b08d313731e5bab9edd69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3772e1d03c5b37d9a00700c5628c8680fa3ab3d7801145f60a3270d2e2aba275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2180b3eabb574fdf196c1ec808c62d602637982a7eca1a01dc9d2b0afeea7873"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ferama/rospo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"rospo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_path_exists testpath/"identity"
    assert_path_exists testpath/"identity.pub"
  end
end
