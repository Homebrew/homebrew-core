class Tidemail < Formula
  desc "TUI email client, supports IMAP, Gmail & Outlook OAuth"
  homepage "https://github.com/allisonhere/tidemail"
  url "https://github.com/allisonhere/tidemail/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f2862c8457e8d309c66420a172882d53cff332a444cdf4d5caa7f31aaa6b9986"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c21ad01de603a3db7efe4ac8147bf2a0168e4cec2778d163d8a2b0d370368e1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c21ad01de603a3db7efe4ac8147bf2a0168e4cec2778d163d8a2b0d370368e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c21ad01de603a3db7efe4ac8147bf2a0168e4cec2778d163d8a2b0d370368e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dceb00be68d49ff84112fca1375c04be01fa7ba29701584664c6d2366d5dcf6a"
    sha256 cellar: :any,                 x86_64_linux:      "ace1fb1e588337e1352a33f49c89e0b2843a876c84c0134d91d5d968981e05f4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    (man1/"tidemail.1").write Utils.safe_popen_read(bin/"tidemail", "man")
  end

  test do
    (testpath/".config/tidemail/config.toml").write <<~TOML
      [[account]]
      id = "0123456789abcdef0123456789abcdef"
      name = "gmail"
      provider = "Gmail"
      auth_method = "password"
      imap_host = "imap.gmail.com"
      imap_port = 993
      imap_tls = true
      smtp_host = "smtp.gmail.com"
      smtp_port = 587
      smtp_tls = true
      user = "example@gmail.com"
      password = "*****"
      from = "Example User <example@gmail.com>"
      sync_minutes = 0
      signature = ""
      refresh_token = ""
    TOML
    assert_match "gmail", shell_output("#{bin}/tidemail accounts list")
  end
end
