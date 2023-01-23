class ShadowTls < Formula
  desc "Proxy to expose real tls handshake to the firewall"
  homepage "https://github.com/ihciah/shadow-tls"
  url "https://github.com/ihciah/shadow-tls/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "f6c4094605a584e242a07776dae3879f1af9fe4ab020c81791349ceff9cbe0d8"
  license "MIT"

  depends_on "rustup-init" => :build

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    # we are using nightly because shadow-tls requires nightly in order to build from source
    # pinning to nightly-2023-01-22 to avoid inconstency
    nightly_version = "nightly-2023-01-22"
    system "rustup", "toolchain", "install", nightly_version
    system "cargo", "install", *std_cargo_args
  end

  test do
    server_port = free_port
    local_port = free_port
    fork do
      exec "shadow-tls", "-t", "1", "server", "--listen",
      "127.0.0.1:#{server_port}", "--server", "captive.apple.com:80",
      "--tls", "captive.apple.com:443", "--password", "testpass"
    end
    fork do
      exec "shadow-tls", "-t", "1", "client", "--listen",
      "127.0.0.1:#{local_port}", "--server", "127.0.0.1:#{server_port}",
      "--sni", "captive.apple.com", "--password", "testpass"
    end
    sleep 1
    output = shell_output "curl -I -H 'Host: captive.apple.com' http://127.0.0.1:#{local_port}"
    assert_match "200 OK", output
  end
end
