class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/zk-org/zk"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "563331e1f5a03b4dd3a4ff642cc205cc7b6c3c350c98f627a3273067e7ec234c"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8f181e8d732eb66c3500a232cd4fb25f771b785389d97cf12f5095854529d10"
    sha256 cellar: :any,                 arm64_ventura:  "f550a1c9d623334fc54b9fa6974b6c833cfc18f57dd0c7ddd0b7a6cb5d79530e"
    sha256 cellar: :any,                 arm64_monterey: "f2d48a5156b155b59870c9251181083fbe13e0f3627ca0fab13ab51c26d1087e"
    sha256 cellar: :any,                 sonoma:         "2b1a82574370f79a3eac0837da3356b69c5517a23bb0040360b10ff3c135c695"
    sha256 cellar: :any,                 ventura:        "91ca091fdca2ae5ae2ada0b295abdd9620dd86ce1c8849287047debc5e91c305"
    sha256 cellar: :any,                 monterey:       "d8509d21636464ed8a75267d2854a23fbdc48da7e9bb6d18083a3a52d45006c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fe3cd970ab00d1736d0eff5302d8b8a2e225fe6a16c1a977ed0745a7659358"
  end

  depends_on "go" => :build

  depends_on "icu4c"
  uses_from_macos "sqlite"

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.Version=#{version} -X=main.Build=#{tap.user}"), "-tags", "fts5,icu"
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
