class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "bdcf779c341916e692f3dad26b33121a2acab6e35d68b95e5415cf1e249b5e2e"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d208680502412041387ce6043a6e6fe833646d572350f81914c402749cbb4284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d208680502412041387ce6043a6e6fe833646d572350f81914c402749cbb4284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d208680502412041387ce6043a6e6fe833646d572350f81914c402749cbb4284"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe2c5f2680c9588372b52575d28e1cae0e41a1cc217e8cc77baf26e1152dcb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e9b478cd907d1f27d33cbca85c347e93e708a5494986843d2759542bf66bdab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054c3dfe8be701c105b7edf657532be3579d66eb863d4baa7fc48617b7d3bf2a"
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
