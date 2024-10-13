class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "26e3153430cd56174494e0f8055711659f58cdf9cd409232fa95eb68586436d8"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "135f35a9ac050ae9f4cf52e0e1fad4026889335b745e59e64ab496ba1bf72155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef7eb8fb2390addc80f62b406e9c54c1d4a51e307f6a242947f588df66f1de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a00a54b357e9d10167fd98ffcefcae7c869b6a701f4d026bd0dd6f8ed1fd509c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ba58040430b6bb16f0077d92a99f785bef81557d321bd7d60b4baf11221e0a9"
    sha256 cellar: :any_skip_relocation, ventura:       "d7d4963009359c6f3912b8e0716c56245493f4885372bd97d7c251898c779abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5529d972c5fb397217c59b1873b358bee2e97ae9098474b73e6c9899a8238e03"
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
