class Tidemail < Formula
  desc "TUI email client, supports IMAP, Gmail & Outlook OAuth"
  homepage "https://github.com/allisonhere/tidemail"
  url "https://github.com/allisonhere/tidemail/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "ac1e7cda883f3f5366beb6e10cb18f2dfb0d477afb4a7d43a6c45b9dcd6950ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e59a77dcddd82f8d86e4293d03516a48391e7a3af547d9deaf78d613d97c3040"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e59a77dcddd82f8d86e4293d03516a48391e7a3af547d9deaf78d613d97c3040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e59a77dcddd82f8d86e4293d03516a48391e7a3af547d9deaf78d613d97c3040"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "013524f914b5baff2f35c4f1feea12e5a413d1f9244ec0fd24075ae28a92bb5f"
    sha256 cellar: :any,                 x86_64_linux:      "31574b3b99635dee24d9d22c4a7a0a9deabed8aa369982eceeffbed9005c296e"
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
