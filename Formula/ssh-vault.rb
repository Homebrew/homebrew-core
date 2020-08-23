class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault.git",
      tag:      "0.12.6",
      revision: "7296095220586d5dc46554444b2e23aba164066c"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d12a7148614bb8fbc97e0e7f72fe04e18da0cd7fb54ee1e5b9308757a2377e83" => :catalina
    sha256 "7b7874972e68f117d14f5027895b6259320abe8db5deda72da09875c507755b1" => :mojave
    sha256 "c6cf671474c67600ddac7bbcae909797c8ba26e16692533b5e82faa153ea9d77" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ssh-vault/ssh-vault").install buildpath.children
    cd "src/github.com/ssh-vault/ssh-vault" do
      system "dep", "ensure", "-vendor-only"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/ssh-vault", "cmd/ssh-vault/main.go"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("echo hi | #{bin}/ssh-vault -u new create")
    fingerprint = output.split("\n").first.split(";").last
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/key/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
