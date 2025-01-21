class Tuisky < Formula
  desc "TUI client for bluesky"
  homepage "https://github.com/sugyan/tuisky"
  url "https://github.com/sugyan/tuisky/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "bd777120b20618c72c6dfe064ca29f7de21e1314fae9be8550f3c527aec5dea7"
  license "MIT"
  head "https://github.com/sugyan/tuisky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdd3cd4bae5e615c5998482164dd60d6b4af71090877a5fc8ce502baf026c507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe534534245333207c7bcbc7cfeb9437c43e6f416aad2aac5052e587778b3ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c5334e7ab773d0a0c86e876cd8c5e9e9790a9db7aeaef43560832292f43ad1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "86aef90f8d8d4fab7abde6b5f82ccef66db610b6f382e6ee2c3bf269ea213509"
    sha256 cellar: :any_skip_relocation, ventura:       "3450e4c9b5066717095354391061520c60fa89f3da742f5349540a84b7d9b940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40debfffda75edcd330e3e46de47bf17073dc8e07dcb4a0ae0443a8118c1deb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgetc.install "config/example.config.toml" => "config.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuisky --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tuisky", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "https://bsky.social", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
