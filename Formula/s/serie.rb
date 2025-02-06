class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "c8bde552d6203de0ebe38ab1a9efd33eb3ab14a1a9df05f68c482166f51b7abe"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d24c479c28bf296ffa7986eeeafeac0fb0806270936121902563c465b65d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "153910fbf979fef21bba4038e5c8747571e91d879b64a9fddaa89dd4d689d2dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8fa82e15e263c4a257a2bc0a7f0f700d966b5c15e3c49dce8b669253b27e85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "58ca58fc4e983d67f0fd1ea68836442c4b81afbfe9045ff1fe97d0202c902efb"
    sha256 cellar: :any_skip_relocation, ventura:       "432a33242b8177eb5ccf72d8417b9dd9ad21a6013acc09754f06e4508c222fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93192b71913144cfc54b2bf35902852037c14e17853299710ec13e3b4b5081ec"
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
