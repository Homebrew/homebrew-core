class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/zk-org/zk"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "563331e1f5a03b4dd3a4ff642cc205cc7b6c3c350c98f627a3273067e7ec234c"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/zk-org/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cf7e7642070b8330680a5e8191ba7210df05d5ce8f344c602f0d80ba7158160"
    sha256 cellar: :any,                 arm64_sonoma:  "cf131f5cb23fdc7b12a73a02ab2165215e3f1e50a179a60748dc916d3a10ba80"
    sha256 cellar: :any,                 arm64_ventura: "c42c8298d5c35c1b1d179993cd5e773906a077c54f0e3647665079d6b14f01e1"
    sha256 cellar: :any,                 sonoma:        "0399d8c1ddbe3f89d1ee3df7ffabfd6bad192eefae58f0ba727a144ed670a712"
    sha256 cellar: :any,                 ventura:       "43f6855036c96139a6e8cbcbc69300dca1a52fcaae5c664f3b3d37bb79f7410b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f02a998e4904760973be2752cacb837676635b3892a780755efbf7226c32d3"
  end

  depends_on "go" => :build

  depends_on "icu4c@75"
  uses_from_macos "sqlite"

  def install
    ldflags = "-X=main.Version=#{version} -X=main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5,icu"
  end

  test do
    system bin/"zk", "init", "--no-input"
    system bin/"zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
