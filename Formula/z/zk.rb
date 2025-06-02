class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "1f30aae497476342203b3cecb63edd92faf4d837860a894fdee4b372184e9ec4"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e650bbd888c32d8bb28e2c2d2ae09499c4709f96001a3951df0b9e91437a659a"
    sha256 cellar: :any,                 arm64_sonoma:  "239224f8f97ad8577bbb05c2960e5dbbca09ee785e77113a86ddb0cc07ca02e1"
    sha256 cellar: :any,                 arm64_ventura: "d2fa155687a35473b7194340e0f2af26fdd2e65d08b34f9e047ca826d8cacbd4"
    sha256 cellar: :any,                 sonoma:        "0370023af2526cce4d2b2a6a34be2fbcef84ca0c268cd16424e9bc60e04bf723"
    sha256 cellar: :any,                 ventura:       "9bb03c28b2e2e21f33c12a9be43b6f00725d996fe4a6bafce68efebc1dc4a94b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fae5f1442ce7541f33cdfe8d629f630317819e05718d0a981c40aff92ef2c28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37a821a7e156bc2c688a7fb144772eb0373476fee7e489a65d1eb80f009ab7a"
  end

  depends_on "go" => :build

  depends_on "icu4c@77"
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Build=#{tap.user}"
    tags = %w[fts5 icu]
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zk --version")

    system bin/"zk", "init", "--no-input"
    system bin/"zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
