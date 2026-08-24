class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "e82ee4753a40df3b9b36564ae504dfce06514d018676481e0d967fd9a092c532"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f61906ac73ffdb3984ecaba9cb54432f7fbb9d3750ced03ee72dfabbe0a555b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fdc82bc1b3824d652ab90c19700abbfe1f49d7d250372b3b08939d7dbc5c048"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ddcd983ef7b9b9bb06aeba8db61a4b11f2698a7647bb7ce3e5dde394c4767d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3901ab3b9294e8a23e745dc0db43a62829bdfd2b419561c88d5cb5a2636ca82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e0de0113174cc4a55de2e7145e72eefcbf9596a8d48e945c0f533e86ba3dca"
    sha256 cellar: :any,                 x86_64_linux:  "4b5818c14f95fb94cd78fac93d430b79cdd6e8c0be2bc9e86b9a66ef96801efb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/iyear/tdl/pkg/consts.Version=#{version}
      -X github.com/iyear/tdl/pkg/consts.Commit=#{tap.user}
      -X github.com/iyear/tdl/pkg/consts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tdl")

    generate_completions_from_executable(bin/"tdl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
