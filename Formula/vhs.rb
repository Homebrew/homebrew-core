class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/v0.3.0.tar.gz"
  sha256 "ff26b9a0079c07fde8f5b68636724acccdaef88729f43d4780bac460bbb1b41f"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7997be66ed2e76cca94170f4a8cce426d332db646e01ac3bfb83c8c2dcf8efe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7997be66ed2e76cca94170f4a8cce426d332db646e01ac3bfb83c8c2dcf8efe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7997be66ed2e76cca94170f4a8cce426d332db646e01ac3bfb83c8c2dcf8efe9"
    sha256 cellar: :any_skip_relocation, ventura:        "c40968b56ad8e396672d6c48468f58d35a9541e8ee2022c64645aef7974028b7"
    sha256 cellar: :any_skip_relocation, monterey:       "c40968b56ad8e396672d6c48468f58d35a9541e8ee2022c64645aef7974028b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c40968b56ad8e396672d6c48468f58d35a9541e8ee2022c64645aef7974028b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ce358ee25e9cf4ad5b300d63f1f51c019f5fc39e42a7916c40b50b343a6f29"
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
