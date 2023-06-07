class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/v0.5.0.tar.gz"
  sha256 "3d9c54b53366504441ad64150af771b39676130cbc22bf14281b026152ab7bc6"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b68bae735c1aa7650697753d47528ac46a6d004d12f5939b3e3a008d6e09004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b68bae735c1aa7650697753d47528ac46a6d004d12f5939b3e3a008d6e09004"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b68bae735c1aa7650697753d47528ac46a6d004d12f5939b3e3a008d6e09004"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9c984fec0685c46bb9dca563a75e4285e3099e6beb7ffb05c3cb1c3cd9f501"
    sha256 cellar: :any_skip_relocation, monterey:       "3a9c984fec0685c46bb9dca563a75e4285e3099e6beb7ffb05c3cb1c3cd9f501"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a9c984fec0685c46bb9dca563a75e4285e3099e6beb7ffb05c3cb1c3cd9f501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0195e5a301fb1fa9d09b41ea8023dc63065d625d9801f32aa1c958c6ce04c8d6"
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
