class Tidemail < Formula
  desc "TUI email client, supports IMAP, Gmail & Outlook OAuth"
  homepage "https://github.com/allisonhere/tidemail"
  url "https://github.com/allisonhere/tidemail/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "6bf0d6172b2b200e73b5b318f18d1098db4071661a33bc5317402eef81888dcc"
  license "MIT"

  bottle do
    manifest_sha256 "c91dc6945312e96a9bda3d62a8564e053ad208a6526b7d53746f15a63ce3567d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cfb0ebc4e94810992bfb70c010b8342664c2fcae5a99b078fb0b2718298dd97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cfb0ebc4e94810992bfb70c010b8342664c2fcae5a99b078fb0b2718298dd97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cfb0ebc4e94810992bfb70c010b8342664c2fcae5a99b078fb0b2718298dd97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a39bf9033e9a0949520436af0d8adaae018a9ed264245501de1a35c937efd477"
    sha256 cellar: :any,                 x86_64_linux:      "8a8ba49afb3f5cda5d4c9624ed258d870e3b45c06cc73aa6e4e7f4acd5dc741c"
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
