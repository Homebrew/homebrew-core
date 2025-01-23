class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "e8538a9019ddfa633ef7e0a6eb417b87fed0555d51b67dc59cb53493e179e20b"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2a2174756cce0799fda2f31c004d1e8193b85e56ed799ecaaaceb841e3ef02b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2a2174756cce0799fda2f31c004d1e8193b85e56ed799ecaaaceb841e3ef02b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2a2174756cce0799fda2f31c004d1e8193b85e56ed799ecaaaceb841e3ef02b"
    sha256 cellar: :any_skip_relocation, sonoma:        "195b57240e893ad37f6fc86d13c78d5ea4d99ff34213ce3ada8e6d66f63a0cb8"
    sha256 cellar: :any_skip_relocation, ventura:       "195b57240e893ad37f6fc86d13c78d5ea4d99ff34213ce3ada8e6d66f63a0cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d203d016045b4a304efbe5a1b9f21dbfce2bcd0fb2fb3e91cd694ac7c37d863d"
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
