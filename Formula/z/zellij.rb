class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "f512621f3f54970ba46fc736e0f6581a438db9da1e5c3a8b69b314296f938a80"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f7df89c09c039467b91f05b4f066e10b97a018d6c3bc52dce5219a2dfcad5e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1e9395bb2b833cbf7f392f901e5a51dc4413ac74731feda81a6bef42f631bef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1963842abf5d2260c18f2d1efdf797c71ea6b13ad09612c4b5a675b5741faac6"
    sha256 cellar: :any,                 arm64_linux:       "1fe71dfb39aec6bcd6886f41ac8212af1a0f27fc56f7e60c10f55e4a01520d00"
    sha256 cellar: :any,                 x86_64_linux:      "55738c7245fecf08af4114fd6fe79b5ff159a8a28a067297de8ba4fd6c247314"
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
