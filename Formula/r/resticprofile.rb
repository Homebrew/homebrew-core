class Resticprofile < Formula
  desc "Configuration profiles manager and scheduler for restic backup"
  homepage "https://creativeprojects.github.io/resticprofile/"
  url "https://github.com/creativeprojects/resticprofile/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "343b956215e3a9124d0ac3d94740668a905eb4b9210e9f50f91baec67144f693"
  license "GPL-3.0-only"
  head "https://github.com/creativeprojects/resticprofile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86f10fca650dddb8aacf40286a5c2b6bc02a0a8dc8cc42257b5a189ccfa74339"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc074b46b0683539ef914135ddebf410555f52af4a0c63a8b832021c23d076f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb322474d629e7d7848af6691d59a342ac32dfe9d65453641fbf286d26c5fda8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cbabcf4e759799a8904660f79523f145eb9b1c2e5d44b3e642d0af52547e2f83"
    sha256 cellar: :any,                 x86_64_linux:      "9b1ce2fa6cf8d23c3dd5c4307e597c33365625c408aefd2b8d84d24ef6f4de49"
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
