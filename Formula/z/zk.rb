class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "1f30aae497476342203b3cecb63edd92faf4d837860a894fdee4b372184e9ec4"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/zk-org/zk.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8968082c06a6eaf3eb8f70b4cd3302e0a6b1672ad2cfe47a3b00410235c1f1b7"
    sha256 cellar: :any,                 arm64_sequoia: "db5840b8488046338aba16f4e3c51999c9c368c4261fdb017413c7e9878efd5b"
    sha256 cellar: :any,                 arm64_sonoma:  "f09b528ae1acfb7a4855b565ea5571bb239da4e21bbe5c814c048973a3656f69"
    sha256 cellar: :any,                 sonoma:        "362f04697342fa2469379e350e70f3f9b85ff927c238a6986697c5a0d5c705ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe8719a65831c3edecb6b69ea6140d0a3c941a146b7dae4692fe4b31b210a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5b8b070341b62faa4a88576396b8799ad33ca2cdf81e33c59139c68797b08ed"
  end

  depends_on "go" => :build

  depends_on "icu4c@78"
  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
