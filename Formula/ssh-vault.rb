class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/0.12.9.tar.gz"
  sha256 "2461ec450622b3aa4497641eeea2fb2da54280413d92c2c455d89f198da6e471"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08dd5698465eb87cca25411576ebb893060b7c802a067bb237e721f000b4d2b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad9804724c8a6c38844ac931a218b20b35dfefe32986f2b9ef4de169635cfea0"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d1af86b0556074ed6b50b9db7506b5e7754e06137b50a4706f6ce0fcb65b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "da32f19d8dee8306904a5c647048898e7e854f0b0eec9bae84a277740d4c2e95"
    sha256 cellar: :any_skip_relocation, catalina:       "fe8f5f23ff032e8ed53a852258a51dddf79172ba879a1adbbfd5d58c9f3d7080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae020819f9490dcfc6d4656322d6ad6017f89bf4fb96dae78668629f967bf2e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/ssh-vault/main.go"
  end

  test do
    output = pipe_output("#{bin}/ssh-vault -u new create", "hi")
    fingerprint = output.split("\n").first.split(";").last
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/key/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
