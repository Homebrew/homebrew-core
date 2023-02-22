class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/v0.3.0.tar.gz"
  sha256 "ff26b9a0079c07fde8f5b68636724acccdaef88729f43d4780bac460bbb1b41f"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fc895264ac5e33149210d576616c476c4afaacd0fe7b6761698dd7974e6575d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ba0ed12af9ddae52628814e955558982ce696faf6933aa224d6454514b25df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f1820091c4fe556b56a292c79c3225e9c3403169372943da7cecd355d0c89ed"
    sha256 cellar: :any_skip_relocation, ventura:        "10393663941fda9ae790ab44432458eb07a859c49852f13469f120a4c7d40b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a5c61e161e4c7bde4604248792866fad17595748bf373d44e5e17251a85f18"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3422b9542c376e2d529e20c8119155f7984812a1c9b51d4d1452870f45c14e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7b61183188a0dd709a946b1af7d453c2c874b413eac905ff5fe1533635dcec"
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
