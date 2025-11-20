class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "b30c37f1c0ce86027288b2e26c7c445bf0ac17608023967ebb4893928fd3e7d7"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c37182e227783ef49b902c0f26ee5942f954474080ea311130eae47051ccc749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52577886ec767716895563462765268a52edb2f08e4b3140362893d122a9d227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baa0337af8214dc4119764cf00a59617fe759e404549c0a85865877e458c2e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b77e39f55d27404159d6618b5c4a0a0453eb11c2cea72d36f7466f65a4783c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7378ba3a892f1085ba51215c4ea86d1c248b914326a5ea27a26e6a2022da053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9224b9978bed5e238dcef82735871adf8480499ffd62d010179f6ab0a4652907"
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
