class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.6.1.tar.gz"
  sha256 "1ff4e88a992193b4c4f9b87f244899d346c159d7bbbbb08dddb57924eb49ee80"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "967445b784347122d1531cfc36a074522c858834d5f6952198a3129098305fac"
    sha256 cellar: :any, arm64_tahoe:       "3467a0e0a0646ee4a0fdaa0cff975f7f473708dad4d43d811e98966ff63353d9"
    sha256 cellar: :any, arm64_sequoia:     "c030148f7f27ede00b49a57dc2cb1e50cb923a25fe28648d460be4b54be40f2f"
    sha256 cellar: :any, arm64_linux:       "54fed0d32e8341bbdb7b7e27fb80a5e26260913037ea25358851a1261d7a843a"
    sha256 cellar: :any, x86_64_linux:      "df646f0f17b9fe3aebade6f1f76fd2560545d0799f89d2b7a8ea43554add9c5c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/snx-rs")
    system "cargo", "install", *std_cargo_args(path: "apps/snxctl")

    # The GUI uses Slint. On macOS, enable the `mobile-access` feature
    # for the embedded Mobile Access portal login,
    # since it uses the system WebView (no extra dependencies).
    # On Linux that feature would require GTK4/WebKit6, so it is omitted.
    # This matches upstream's macOS build and its default (non-webkit) Linux build.
    gui_args = std_cargo_args(path: "apps/snx-rs-gui")
    gui_args += ["--features", "snx-rs-gui/mobile-access"] if OS.mac?
    system "cargo", "install", *gui_args

    # snxctl exposes completions via a `completions` subcommand;
    # snx-rs and snx-rs-gui via a `--completions` flag.
    generate_completions_from_executable(bin/"snxctl", "completions")
    generate_completions_from_executable(bin/"snx-rs", shell_parameter_format: "--completions=")
    generate_completions_from_executable(bin/"snx-rs-gui", shell_parameter_format: "--completions=")
  end

  service do
    run [opt_bin/"snx-rs", "-m", "command", "-l", "info"]
    require_root true
    keep_alive crashed: true
    log_path var/"log/snx-rs.log"
    error_log_path var/"log/snx-rs.log"
  end

  test do
    assert_match "VPN client for Check Point security gateway", shell_output("#{bin}/snx-rs --help")

    %w[snx-rs snxctl snx-rs-gui].each do |exe|
      assert_match version.to_s, shell_output("#{bin}/#{exe} --version")
    end

    # Probe localhost (nothing listening) and fail fast without requiring external network.
    assert_match "https://localhost/", shell_output("#{bin}/snx-rs -m info -s localhost 2>&1", 1)
  end
end
