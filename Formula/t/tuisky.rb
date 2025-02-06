class Tuisky < Formula
  desc "TUI client for bluesky"
  homepage "https://github.com/sugyan/tuisky"
  url "https://github.com/sugyan/tuisky/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cedfc4ae396af0dadc357f93b65a9f35cfda3afca1a5ad41d9d27cc293bc8df4"
  license "MIT"
  head "https://github.com/sugyan/tuisky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bec1436fe2ba2762e82506425c4e86bdc373c945ea5a7b98a9d3be4ccf1abcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eacb4566e7efb2db350967d77f293d5783ee22d89c5011ebbc4ee556507e671"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f5790a02cfde8e721b118708d057234399f87f04d878328091ac85937d23657"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbad1992312186bb58bd8e409a4272fcc6024c4f7f9331915ddd72e32cea6d3d"
    sha256 cellar: :any_skip_relocation, ventura:       "b76b6484e2b5d50e470d92db22c19cd6586ba87505a55312546777338c5c8dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913b599a66307525601ec61513440037544cf246df75a68d28208e871274fd67"
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
