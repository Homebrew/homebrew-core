class Wifitui < Formula
  desc "Fast featureful friendly wifi terminal UI"
  homepage "https://github.com/shazow/wifitui"
  url "https://github.com/shazow/wifitui/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "f3fb64564fd5cd896a16aa36b8214733c88344e6154a63d37357dd9ecbeebece"
  license "MIT"
  head "https://github.com/shazow/wifitui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4327153f768cd60cb98933ad7ddc6de6f5d07a594993a79fef2fe67e633e044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4327153f768cd60cb98933ad7ddc6de6f5d07a594993a79fef2fe67e633e044"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4327153f768cd60cb98933ad7ddc6de6f5d07a594993a79fef2fe67e633e044"
    sha256 cellar: :any_skip_relocation, sonoma:        "df10128b2d4cafa679004cdb63f7ed5d37c2052a345fd0228883367b368e86e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429e7ea8119a0626f9b611e1b054c560e40880491b08a40cb030d72cce65986d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a5b31b734814860eddf50a31d6154aade5998403b4e64cd23e5735845a0412"
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
