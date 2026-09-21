class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "5cbe711437d2a61afd9287165f6aca0bcccb9ab1473633665a5b11ed55467852"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5a25e2849e2517a3e1f2928d456c68a7a7d51ef3883baf7b17785d42e4c4ff0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ac4e67e143432b9dbbf0e38eee83a4e4f8778a00d8ca5d0537fcf49d66e1ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8dca31c714c218ad5f09631a57b8f99ead0ecbbfc11979eb879ee9949ce8fa87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7c0b5dfc811c7064b4674c3126a3aa5d34222ea4aae2f9cd7b691b9e300b0ac2"
    sha256 cellar: :any,                 arm64_linux:       "c4e142dcc8e6219146be785311bef4d8349f972554d3d912d1654d633e8142f7"
    sha256 cellar: :any,                 x86_64_linux:      "e1b493e3cef440a32ce32235a07e1974a3f63ebc33acdd4709a484747ead835e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  service do
    run [opt_bin/"zellij", "web"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/zellij.log"
    error_log_path var/"log/zellij.log"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
