class SnxRs < Formula
  desc "Open-source client for Check Point VPN tunnels"
  homepage "https://github.com/ancwrd1/snx-rs"
  url "https://github.com/ancwrd1/snx-rs/archive/refs/tags/v6.6.2.tar.gz"
  sha256 "141caa997a36b09dbfeb5931c021a9bfd3138f31b95750384f3faee62532b03e"
  license "AGPL-3.0-only"
  head "https://github.com/ancwrd1/snx-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98187075d26c17b012ca7940099ad4ab3d8c7c1e903946b3a681f27ef7bbde20"
    sha256 cellar: :any, arm64_tahoe:       "3d6a7d7ab713f0b031d2a99f0056943655fd6631026fe20edc643c8d58942ef8"
    sha256 cellar: :any, arm64_sequoia:     "47f1a2f7a0b02d982d8e4f7a3cb8fed21a8630ffd938d5a2a157feda79940d75"
    sha256 cellar: :any, arm64_linux:       "9ef8a1108267658d1e4f0f5dccecd6691f7be6048ee8cf62c3dd4d9606e39081"
    sha256 cellar: :any, x86_64_linux:      "c1ae8263936ecace90937712334bf4b69e2e45fd9a0b60827fdaf1f760074f4d"
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
