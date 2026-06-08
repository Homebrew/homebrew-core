class Resticprofile < Formula
  desc "Configuration profiles manager and scheduler for restic backup"
  homepage "https://creativeprojects.github.io/resticprofile/"
  url "https://github.com/creativeprojects/resticprofile/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "3b8a26dbc17ac9268108de59ce0fedf831fe5bc8c41f7b36b8341fa9157b8f5a"
  license "GPL-3.0-only"
  head "https://github.com/creativeprojects/resticprofile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f986d017c8ce9414c2f1ad6b1b0c16287decbcd5f923e8bf82d36a9f098cbeb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08755807092ca3abb8bef66adb739364686facc2bf82884a9e0d657d7467be7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253287995bf155d81c1a21df23eff213f46dce7fdbeb593253f0ed5d5924d42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a48b32ea01fff0fb9d80f038b201b96ee36b99c43feffc831d4a39b943a22f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e2912941204582a3c1f6229dda13ab9b5e3d9e7878f78f8b09862f1a454727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867d857a556e6e0fc36fcf1aa7eae9257dd70a097248762130787fcfe0647ae7"
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
