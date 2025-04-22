class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "71cb537273c1dc11201406000e0375699d31a3733d849aee6921677ddeb4c425"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "345a42e6b1699ad7b84f4d59e3555a86ea6b1757517b2adc96598aecf311523e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2b9d99ffe8a6cffcb8220f2486fc9cdc71153939173bbd836e05fb54e9a519a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "943b140e046c2c69483d2007c30612e8f80a69753257d13a186f3fbfc114e0e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "718e0911c5ca0626fe5f4d852337938506c1a9ee5a75a6a040e38d5711d8ee53"
    sha256 cellar: :any_skip_relocation, ventura:       "df389a856674bbac465a5df01b8a1a6bce0cfaff97361053882a4cb5b8d0d50e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c84b822de8c67d5c7cdca772597789ed008e6d0426952dcad94947e346057103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a88bd6e2225d01eb20c7db3933110c44380ebca5791c0d7fcfe8ebad5a17c7"
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
