class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/v0.1.1.tar.gz"
  sha256 "d5d6dddd8f9fd2beb6d1ea232efaa1c9dbfa4e53011d2aebdbe830d952665776"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2354e67931e0311a6b8b7bb28f0204383fe2324ecf36144ba64f5a398d5e604e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d96d21a57f00b260001c07bf76e3191750c7d3508a01025d39bbc3ff5d53ba5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0581aaa5909a2f87191f4e282bc5dc653538771e276d12502e79031fb5cffab2"
    sha256 cellar: :any_skip_relocation, ventura:        "f78659645a4ccea80ab43e88013e6f5a88ce8ae0593d1cbe94b8c4d2bceca3f2"
    sha256 cellar: :any_skip_relocation, monterey:       "cb794674bd995b27da634565b9f5556c7f966b905d3ac756c263ab24b146b360"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ec7ad80790a484f69647f34f83694d98c7a0054eada056d6a59794d41ea746"
    sha256 cellar: :any_skip_relocation, catalina:       "ef79090874ed53d67ab79b92641543f7b12b06cc02bdcc0cc8710d761140ac88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d91655fd4980b7ed452656acc2abbb8a5e8457a8816e22a5b25af8a677c20a"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", "completion")
  end

  test do
    (testpath/"test.tape").write <<-TAPE
    Output test.gif
    Type "Foo Bar"
    Enter
    Sleep 1s
    TAPE

    system "#{bin}/vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
