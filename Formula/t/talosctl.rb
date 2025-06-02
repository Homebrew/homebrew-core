class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "1ee5ddb295032bb9d47428bb105d93025143c8c584305ffc4084c7a101d223a3"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e57474aede2e5f54c67acaf93a87a02177b51158217e81320468710cbadc1bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ebab80e2ffa936501bc82e46f0ab223702000be8c21eb183b304cbc7e3aada"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bfd170218075b66cebaa4b440ed293e045c82b28a3c540d3cd763149236d77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3edb48b1a74f0373a0e1110c77104791738a7adba6931d4e136dd2fea4939a"
    sha256 cellar: :any_skip_relocation, ventura:       "b14484e5790e7c079301564fcef8029c3a14e036e756d2eb458154f52b2dfff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7454ff4585fe02ca74d330b92fc74bc2f1653ce83e595794e1a2dbb4a7223c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48c87586ad6b567ac27ffca8a5d734e9957de789e6a494e070fc6605e3491a3"
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
