class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "4e10f53224a701d72c11e27a30b0fb9473bdaa102a092bf3969af340a08eeb58"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8846fc17eed13a8ce74bd06ebdb443f3b47358ab0a20868b08b3deb62a59db4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd93d65832db555621d5405729168491ff9385d105ea7fa328701705ee4cca90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f1469bfadf362624e8f498d369cbf4bb61b3177fd7688e709a3d7f0998f74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f11f482c273ee92fe473904f579292d99106034a8b04c7e44db7f716308b3ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b464faccb4f0aeb8808f850977422376891cfea8fb23976221b4153cac7e689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f4111b666cd2de603b260f02aa75ad43983ba40a82a0bd293101bcc9105670"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
