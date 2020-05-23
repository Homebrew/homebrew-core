class Turbogit < Formula
  desc "Keep your git workflow clean without headache"
  homepage "https://github.com/b4nst/turbogit"
  url "https://github.com/b4nst/turbogit/archive/v1.0.0.tar.gz"
  sha256 "858d2cffa7cae3cf9980d871b90d622f970347e081e7e1b5f8002a53d22276fe"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/b4nst/turbogit/cmd.Version=#{version}
      -X github.com/b4nst/turbogit/cmd.Commit=Homebrew
      -X github.com/b4nst/turbogit/cmd.BuildDate=#{Date.today}
      -s -w
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/"tug", "main.go"

    etc.install "config/tug.toml"

    (bash_completion/"tug").write `#{bin}/tug completion bash`
    (fish_completion/"tug.fish").write `#{bin}/tug completion fish`
    (zsh_completion/"_tug").write `#{bin}/tug completion zsh`
  end

  test do
    assert_match /Version:\s+#{version}/, shell_output("#{bin}/tug version")
  end
end
