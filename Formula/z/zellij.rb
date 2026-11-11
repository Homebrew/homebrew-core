class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "2dfa237fea447f3cc98954e81b0097b9d25841010036720e11f67880fe7861f0"
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

  # Updates for yanked chacha20 and minimum openssl-sys to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl) if OS.linux?

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

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 592e22320..72c51a0f0 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -698,9 +698,9 @@ dependencies = [
 
 [[package]]
 name = "chacha20"
-version = "0.10.1"
+version = "0.10.2"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "d524456ba66e72eb8b115ff89e01e497f8e6d11d78b70b1aa13c0fbd97540a81"
+checksum = "65c35e4b699c7e15ccbe7ee35c005e4fc0a278d22238a2857e6ce2dadeda1b06"
 dependencies = [
  "cfg-if",
  "cpufeatures 0.3.0",
@@ -3354,9 +3354,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
