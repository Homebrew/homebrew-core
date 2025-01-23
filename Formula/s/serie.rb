class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "34a6afce36e3517449d92b6428ec062c21d64a3569c0a8d0f514641f5a87d0b3"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c22424da6fa274671751116389926fbc1ff4408dea9e8310fd8118817a327cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "440e60d5187cf43014a244fed049717a4c8ee0d1295ccddc279a0673a70d358c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "241df69f243f1379c5a182bd713a19b7593078c89b107bc15366fab1342d7b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dcf46dda281dbbdb5a85051990c5c987326584986b8ebb272f908571b0f7541"
    sha256 cellar: :any_skip_relocation, ventura:       "cb59ff1c7ff3a4bcb4d08a7a77b4cecdc7ddebeb7bcd469db9db55d34cd5306b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "377b6dd3998041f10a68b164c740a6635757220928e16cac812ebd43fb9bf142"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
