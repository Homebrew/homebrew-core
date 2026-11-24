class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "f512621f3f54970ba46fc736e0f6581a438db9da1e5c3a8b69b314296f938a80"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    manifest_sha256 "49b204808faea3095ed9905b2e236ea3ec488f55d89e61127d7ccaea5b3549ee"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "669a0f13a411e37c041d881bd0b9c539d0d0c3dd39a31adb3c7d60e45c1ebb0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4425d2be6ac9bfd1d430ac66206c8ac2dc07279bd75a64b5e599a243051ca20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca96161d925e132f3e319dc73d787a32f00ccb1846262ad209d0607a885b250e"
    sha256 cellar: :any,                 arm64_linux:       "18cd60e697c4748430ff30a4de1fc81f0945a8e9694ed336d6081979c897b580"
    sha256 cellar: :any,                 x86_64_linux:      "45ba5683f68de058135dd3e2d18cf05a55ac98b90e54e7130a21498f2f9f1f5f"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4" => :build
    depends_on "pkgconf" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(dep("openssl").name) if OS.linux?

    # Remove vendored_curl from default features
    features = %w[plugins_from_target web_server_capability terminal]
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  service do
    run [opt_bin/"zellij", "web"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/zellij.log"
    error_log_path var/"log/zellij.log"
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
