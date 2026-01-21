class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2e5e565eaad529b769dc2f558256c7a0aa51bdf4c1baea4353f9e533799395f8"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e2791a7bddacd152a1091695170b243851da70d59e260ff8ac4c8babc5ce903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e2791a7bddacd152a1091695170b243851da70d59e260ff8ac4c8babc5ce903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2791a7bddacd152a1091695170b243851da70d59e260ff8ac4c8babc5ce903"
    sha256 cellar: :any_skip_relocation, sonoma:        "10f4706fcd36c6289ec2220c4d106a6c1ddb750ec36162c5cc973d4872dc061e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e7de0d2d8bc89e9913306a60e0c9706a2a76254acc5a21768753f77ed16bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402b9c5aeca965c896321621037dbc2bb1a90c177ae735a5a4f55685e3272578"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wifitui --version")

    expected = if OS.mac?
      "no Wi-Fi interface found"
    else
      "error: dial unix /var/run/dbus/system_bus_socket: connect: no such file or directory"
    end

    assert_match expected, shell_output("#{bin}/wifitui show nonexistent_network_id 2>&1", 1)
  end
end
