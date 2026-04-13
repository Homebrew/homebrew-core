class Resticprofile < Formula
  desc "Configuration profiles manager and scheduler for restic backup"
  homepage "https://creativeprojects.github.io/resticprofile/"
  url "https://github.com/creativeprojects/resticprofile/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "6f550580877d172965f29398a1fff2a11075d0592f09324b1d33efae6f7bf6fc"
  license "GPL-3.0-only"
  head "https://github.com/creativeprojects/resticprofile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe9f71446c080af341af94906dfa3192230d1d5d77f994fe7bbbd9a1d0cf930d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7042dbd3c8f14163bc1bf332be459b350d80c0f62f35349e7a035d2c9119e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf07c7238a96b388a1fcfe2daa90346569ff1af19cf2842c3dc21cebc628cf36"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd52a3a89d0ab22eb9e59b99d80b556b83c21e5a9679449c88639b0862e9e481"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "497420f4d7613d2e3461e0041ade56470320c3752274bf893c6b34f35817080d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02f4d8c0929e06c0d62ce703a5e1bbd59419b82be2af632a611cf76fb6edb07f"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
      -X 'main.version=#{version}'
      -X 'main.commit=#{commit}'
      -X 'main.date=#{time.iso8601}'
      -X 'main.builtBy=#{tap.user}'
    ]

    system "go", "build", *std_go_args(ldflags:, tags: "no_self_update")

    bash_completion.install "contrib/completion/bash-completion.sh" => "resticprofile"
    fish_completion.install "contrib/completion/fish-completion.fish" => "resticprofile.fish"
    zsh_completion.install "contrib/completion/zsh-completion.sh" => "_resticprofile"
  end

  test do
    (testpath/"repository").mkpath
    (testpath/"password.txt").write shell_output("#{bin}/resticprofile generate --random-key").strip
    (testpath/"profiles.toml").write <<~EOS
      [default]
      repository = "local:#{testpath}/repository"
      password-file = "#{testpath}/password.txt"
    EOS

    (testpath/"file.txt").write "Hello, Homebrew!"

    system bin/"resticprofile", "init"
    system bin/"resticprofile", "backup", "file.txt"
    system bin/"resticprofile", "check"
    system bin/"resticprofile", "restore", "latest", "--target", "restored"

    assert_equal (testpath/"file.txt").read, (testpath/"restored/file.txt").read
  end
end
