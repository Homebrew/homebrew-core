class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "626dee9c98d231f1ac9595e06ab61d3920da5711891f39c7d3b7ec69d5640ef1"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90609377f88e14321a86239c3fc2321711087777aa7351b9172e7ab84b2c0e97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "594d4c07a9b8642857dc4939ff5c6f7fac259adc64e9224943cc2864a64df7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65cc576ed95c5411a311ef4db0be72e5aab5cb69e259401b37821c4e0f2c2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e9b5e6921a3978f1e3f02e9a06bf6e610ee93b0a06e54d00122dce693a3d336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8daf36a80fc5f212d7ac379f033b1e88292fc597404433cc4779e340be6e6e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f049daf4475bf3b4cf51964b2882fcbff83520c6859dba742cbd99ed5c33d593"
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
