class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "ba9fbcb40133d1734c580ccb6b0fcae9673bf51d227f00877ac581c56ad15b77"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95ae3e96bc433efaf012880b89edb1e511719bbd497adea94280c0c7587fad1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95ae3e96bc433efaf012880b89edb1e511719bbd497adea94280c0c7587fad1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95ae3e96bc433efaf012880b89edb1e511719bbd497adea94280c0c7587fad1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9319ad58ab9aadf0ac70f0411ce054059411408faca66a9b8b04c6f113c2024"
    sha256 cellar: :any,                 x86_64_linux:      "c3af24c6574021d6e94b29d434045f6ac24789b11b6788e956968fd0746c5719"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")

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
