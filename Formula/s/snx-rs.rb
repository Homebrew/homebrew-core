class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.2.4.tar.gz"
  sha256 "37f367ef8798dc810db57729acf40bd7696cb74144311a190070e159f4de6d7d"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "fontconfig"
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
  end

  service do
    # Mirrors upstream's `package/snx-rs.service` (`ExecStart=snx-rs -m command -l info`).
    # The daemon manages tun devices, routing and DNS, so it requires root.
    run [opt_bin/"snx-rs", "-m", "command", "-l", "info"]
    require_root true
    keep_alive crashed: true
    log_path var/"log/snx-rs.log"
    error_log_path var/"log/snx-rs.log"
  end

  test do
    assert_match "VPN client for Check Point security gateway",
                 shell_output("#{bin}/snx-rs --help")
    assert_match version.to_s, shell_output("#{bin}/snx-rs --version")
    assert_match version.to_s, shell_output("#{bin}/snxctl --version")
    assert_match version.to_s, shell_output("#{bin}/snx-rs-gui --version")
  end
end
