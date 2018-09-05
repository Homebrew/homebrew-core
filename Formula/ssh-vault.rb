class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault.git",
      :tag => "0.12.4",
      :revision => "cc0eb0daebad1144583a943f486e086d300142b0"
  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0626c48246281ef41d5153ed6b50349adef603a944b5b24e0575bb40b3712785" => :mojave
    sha256 "178173c00bedfa7a48c5381d03596e8164caeb7c3ccb4447579fcdf66149192f" => :high_sierra
    sha256 "886172cdae4a8cbbb7ab4caef859cc397c39de3b216044d920153e11d01cc828" => :sierra
    sha256 "74a103aab77feb90dede16015dfefac1cb27483630658fa6c0f5a93aeb7fefb9" => :el_capitan
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
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
