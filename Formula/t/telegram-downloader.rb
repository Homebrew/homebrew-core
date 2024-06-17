class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "26f7a65aba24d0f925590d3d0ccbfb8c0e47960e0660e94ec1086076a27eb490"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fffb10c1234a098131b14eb80a761a97e28d421e1028552f47a080ff570c480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "926492e10b944aa36d389130c8b722595121c4916d384bb5ac5f6570c058a803"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aec643d4cc6153e6ff5185ca9fbede04fd13ca5d753ef8b9308aacda92dae6f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f97c812527be2b27d78f8a65c19c96e5fd24ef75a57e2422febc7961ddb5cdb2"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4b57c9676ea44580a54e1cc8b21fd2582ee14fcd2e088efb45f7984bb18a20"
    sha256 cellar: :any_skip_relocation, monterey:       "05ea97ec1a9d1f2168599a2b15d9e89b40a2ac722ed9e5c553335f51a6d8e130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b2e0eac6be73a74d8696e32461019cf5426ccad33d1069eb36a8ed493da37e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/iyear/tdl/pkg/consts.Version=#{version}
      -X github.com/iyear/tdl/pkg/consts.Commit=#{tap.user}
      -X github.com/iyear/tdl/pkg/consts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tdl")

    generate_completions_from_executable(bin/"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
