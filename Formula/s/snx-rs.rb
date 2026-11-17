class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.7.0.tar.gz"
  sha256 "5aaa03284d696e5b2f503a337645094cd17fa7b6ee7ffca4ecf9f78289431015"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1b6e2806b3f4f2894e63908ff150ad65048b7471626cc82bd40995f30c44d78d"
    sha256 cellar: :any, arm64_tahoe:       "40dd6b4dcc24e0a90059463274ca92a694c150cd98690297192cac5f2889345c"
    sha256 cellar: :any, arm64_sequoia:     "15721c484458f1f3c73f0f965140cff6a978d26b2c911c56f5c66de0f70fa97c"
    sha256 cellar: :any, arm64_linux:       "9df433267b7349e9f055dcccd4bfd869ea9580a39d0f770f93a55ea56f298d2d"
    sha256 cellar: :any, x86_64_linux:      "9b56154b17b8baaa3fcd18ec8d4fbf7280056302135656b837c61bfc29a33967"
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
