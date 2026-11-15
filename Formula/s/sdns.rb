class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "63ee0d598681965afd09b9010d1594840bc7bedf1c4386af73ac30a57eb018b5"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7738036d0e31b30ae9957bfdbef64eebf1b1c3ff1c1d86946976a7c0d4e737b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3401e556e8a796cf9f63e3f164b5b0311a7f0f97f39af856e4a72e3965ff257a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dbd0604a691265ea9d0026e28fb5ec06ae2aa4cfc15f69810368d84f1125521"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a492f3fdb31095e3d9feba86f7bad70801e6c13594b300e77616d3e45138188"
    sha256 cellar: :any,                 x86_64_linux:      "0f2cd33734ff8239365ed68a5fa774cc098effc1ebef804a40c1c727ef123152"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    require "open3"
    stdout, = Open3.capture3(bin/"sdns", "--config", testpath/"sdns.conf", "--test")
    assert_match "Default config file generated", stdout
    assert_path_exists testpath/"sdns.conf"
  end
end
