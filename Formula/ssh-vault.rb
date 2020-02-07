class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault.git",
      :tag      => "0.12.6",
      :revision => "7296095220586d5dc46554444b2e23aba164066c"
  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12e3e14671d317e1e337a81348962dd1abcad4994eb36d3d088f367cba4174b9" => :catalina
    sha256 "a77d9ec9d764fec99d165746b07282934357081d313be6dd43f85de40534299a" => :mojave
    sha256 "8670837a09a5eb5fccef4f7f6393b25ef208fcb332fcde26ecbe0fee66f04e5b" => :high_sierra
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
