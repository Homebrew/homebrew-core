class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "19f38c588b11c3c69c8229182f875ac61a529604e6af73c00ed6259dca3880e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51094fae3c63652eea64bb8349e233f0d0302d17f1524b1c78f1c41987bf9d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a8664e984452e7a7c2c310b82e7793096d0f349efb1f973acb569cb592bbe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ae471a22dbc4548051afc05d37baf509a4c6d1b163a6a858c1aed1634fc2846"
    sha256 cellar: :any_skip_relocation, sonoma:        "092d5767abe9f5633e513ca112ab08c941fce37350802faf04936bac62b2013e"
    sha256 cellar: :any_skip_relocation, ventura:       "9ed604580f9dce19f5aa4ca3982f54f163650a5c7b1c9700728f2f4944b83d09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93494c7aa1e7b2913ccb64abe25d1d180d528482746873cf692e28cfc54f749e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "176e0670fd171ecfabc19f4980ce4486d2ce685c0c2e9a3596ba18b333123eef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
