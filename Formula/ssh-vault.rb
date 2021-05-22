class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/0.12.7.tar.gz"
  sha256 "1fbe2036f4af167fe034371a7171577d732c52744b7093142cf5c836dfa5e2f2"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "ca3ab49ebbaa91eb10f8b176cd4bb12c6bedcfc83705b03182450daf7b667473"
    sha256 cellar: :any_skip_relocation, catalina:    "d12a7148614bb8fbc97e0e7f72fe04e18da0cd7fb54ee1e5b9308757a2377e83"
    sha256 cellar: :any_skip_relocation, mojave:      "7b7874972e68f117d14f5027895b6259320abe8db5deda72da09875c507755b1"
    sha256 cellar: :any_skip_relocation, high_sierra: "c6cf671474c67600ddac7bbcae909797c8ba26e16692533b5e82faa153ea9d77"
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
