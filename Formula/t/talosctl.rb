class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "339b4264bbdb0ff67002588f2a7826a97cb3a0218148891e47dcf908d837ee24"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4a58b8e68490c5d6e85dc5cb5e94bd1a1ba5c152d65dd4ea9f5247b7392a5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d481d5806bbb5ca62bf8a565f24ab3d26b6b540f236e4a7500ee08f092ecbe15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30ddaae461d4f24b10d9ec9350de30a1b4b58cba1a356f1d2352718c6bff2729"
    sha256 cellar: :any_skip_relocation, sonoma:        "6541a3f9a246fd55b8ebfad90cf81d1813648721ecb704ba72469ad7df519f8b"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b42da451cd121bfa826ad57fd2a274f71fd22d2d0cf3eff12aa296c6285d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a6cfb6a321fbecb9aae7d77090c6f8eadf197f20c50da7d40df0a518ad9ab79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143dacab671933d30da829505ea1055dbcf80faec6e160d15930a36e7d4190c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
