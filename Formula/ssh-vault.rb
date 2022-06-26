class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/0.12.8.tar.gz"
  sha256 "db20269f43ecd98064cef784ef3c7aba3e0eb25ad88ee7449ba2d3d71f13b191"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2334b9e74cfa0f96d243b941564662863ee2f19f8a2e61d1dc024d52360310d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d31b872e937be5b52e321628ff7f05471c25f42e72dc3e4566580d919613c30"
    sha256 cellar: :any_skip_relocation, monterey:       "6cbb0e108b1c9aba5aa319323926f552db41f90dba885155821d460004c74e66"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcb7faca3f1ac56161e9ea91a7e543cf705222d1432d866a7127746f869b79ba"
    sha256 cellar: :any_skip_relocation, catalina:       "8f4fc6e1e12a6eb2cff23b48c34568f2643d6c4570160c459e3ce79b66c5d7a5"
    sha256 cellar: :any_skip_relocation, mojave:         "b3d07f9f64964782d4bc5d1b20218e016f8d4ee07bbb99a35fc5b1b0a0baa903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ccdc30d8485aca427e4d4603c22604d53fde4e5dcce3f6b0dd84770e82c272a"
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
