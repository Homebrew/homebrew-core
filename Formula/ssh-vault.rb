class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/0.12.7.tar.gz"
  sha256 "1fbe2036f4af167fe034371a7171577d732c52744b7093142cf5c836dfa5e2f2"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "899d6b9dc54456774fd31aa01dbffa3c7c054f5792524a62f1af479775693ae8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4756846a8d3c600174697c14690d4a58153aca8a3ed091a7d50f8f879a91cbfa"
    sha256 cellar: :any_skip_relocation, catalina:      "8527d8a5b043f0cbac3be3baf52fa9e98957e4be715e6ce3ba5dbde6be167c4e"
    sha256 cellar: :any_skip_relocation, mojave:        "4022c12c0a3f06ca6c3ea6a9ca5188b8b7f8962afd1baf4510da3e660b28e563"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/ssh-vault/main.go"
  end

  test do
    output = shell_output("echo hi | #{bin}/ssh-vault -u new create")
    fingerprint = output.split("\n").first.split(";").last
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/key/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
