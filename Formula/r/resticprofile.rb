class Resticprofile < Formula
  desc "Configuration profiles manager and scheduler for restic backup"
  homepage "https://creativeprojects.github.io/resticprofile/"
  url "https://github.com/creativeprojects/resticprofile/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "890e768a98948a85f5f7594a666784159209423f3688bf87b3f9c103b3c735f7"
  license "GPL-3.0-only"
  head "https://github.com/creativeprojects/resticprofile.git", branch: "master"

  bottle do
    manifest_sha256 "6efb2bcc1f05271399cb7d069cd53b3305252efdf164eaad98de72d27b2a10c1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a9a5c3a633b82cb4fac64a5a429d1502931d591c4c918b7ff6cc4415c9e1c83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "401c1f515dbe0678bafdc1bd94011178fd52f77906678e999f5067da2874eeb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5d137cd5bc88fff7a8b418d7c30261275c0ee3d54f47b49f5f9cc04f3900103"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12e40d0dc1a986d3d3e6d633cc1462705f035aba680af56fb3f98eee98ba3d4e"
    sha256 cellar: :any,                 x86_64_linux:      "403a33da9ea51d519769940597190b6c697e36513bd2b723907e4baca58593bf"
  end

  depends_on "go" => :build
  depends_on "restic"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser, tags: "no_self_update")

    bash_completion.install "contrib/completion/bash-completion.sh" => "resticprofile"
    fish_completion.install "contrib/completion/fish-completion.fish" => "resticprofile.fish"
    zsh_completion.install "contrib/completion/zsh-completion.zsh" => "_resticprofile"
  end

  test do
    (testpath/"repository").mkpath
    (testpath/"password.txt").write shell_output("#{bin}/resticprofile generate --random-key").strip
    (testpath/"profiles.toml").write <<~TOML
      [default]
      repository = "local:#{testpath}/repository"
      password-file = "#{testpath}/password.txt"
    TOML

    (testpath/"file.txt").write "Hello, Homebrew!"

    system bin/"resticprofile", "init"
    system bin/"resticprofile", "backup", "file.txt"
    system bin/"resticprofile", "check"
    system bin/"resticprofile", "restore", "latest", "--target", "restored"

    assert_equal (testpath/"file.txt").read, (testpath/"restored/file.txt").read
  end
end
