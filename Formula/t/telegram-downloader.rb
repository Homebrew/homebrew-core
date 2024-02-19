class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c44bd131a11239d94af5df1a4323ab76185b9b023d9f3c2be1b4a3846c625f07"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc72dd439c94addb26cd190f506fb095d8d078369368319dbb5e034e200617ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c118f31117e545f8d5049d399f87b884c3c9d1bf01adab5481166335dfecebe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6946d6705efd1f1854df426430b17d000e01cbd39667720fc806bec1f453b4b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "11e1ea354ad21cead299da5cfcaee40b4c31bdb5750ca9d3000e40e2912a13f6"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5d0362484b2ea7a5407725a8066728eb99116b14d00ac607d79e7f9ada2db7"
    sha256 cellar: :any_skip_relocation, monterey:       "ea92b30bf438845735cd237dd6564d113ed25de1b443095e84d1264709c85466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0481a0ffa6eb0e411c755bf4f1bbf17a2e58e60dae99466e536a4026434d8bf0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/iyear/tdl/pkg/consts.Version=#{version}
      -X github.com/iyear/tdl/pkg/consts.Commit=#{tap.user}
      -X github.com/iyear/tdl/pkg/consts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tdl")

    generate_completions_from_executable(bin/"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
