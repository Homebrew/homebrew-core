class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "c08b8502989fe7e9626c02938f3fc512c2a4ba21f839f455d20d7eb1da7bc39f"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0edf44b9c84f56fb39ae8982b9190380cc129c24a489d3fde161ab733d9219b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0edf44b9c84f56fb39ae8982b9190380cc129c24a489d3fde161ab733d9219b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0edf44b9c84f56fb39ae8982b9190380cc129c24a489d3fde161ab733d9219b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e57d7d0c7a2e44c65e7db0b344de2ba912362c648060b7ccd9f5de6bcec784d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc1dcb65b659c63f95e43f6347e2cb290744431c6f0ced771c25326d098155e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15290cb92528067b54e83f001e151ff66e39b1b94bba44174e442bb803dccc70"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.tape").write <<~TAPE
      Output test.gif
      Type "Foo Bar"
      Enter
      Sleep 1s
    TAPE

    system bin/"vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
