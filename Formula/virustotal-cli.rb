class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.9.7.tar.gz"
  sha256 "3effbc318116ddfdc41c2d8e5e885da93f43614dbf1704557bf9f347553bd5ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d59a45d938c717eb4a973fdf0c9cd66d34275823dfb0ef8b7af19c2a35921e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3140b175d8ffc0311f328dd84879cb9cb0a6926dab057d714fd8f7185551cf41"
    sha256 cellar: :any_skip_relocation, catalina:      "19de8c8e8db5fb3f45eb14fe1ad1beba7ff4824e1bf7ac16911f0a3c2e486390"
    sha256 cellar: :any_skip_relocation, mojave:        "da799e16b4017767887fa424b13c0cc846a4eb25d31e2f63d50903d581de8b6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-X cmd.Version=#{version}",
            "-o", bin/"vt", "./vt/main.go"

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "bash")
    (bash_completion/"vt").write output

    output = Utils.safe_popen_read("#{bin}/vt", "completion", "zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
