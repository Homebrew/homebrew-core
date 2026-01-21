class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "dcb6c3d2b41c3712c75dc8f3d69cdc3b932ef9a288e7808df74617af5b487af5"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8339d29ba5273b92d44fc6bc5049a32983c07f2f86cae0b973ba228738d841c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "008a73b9922a457d1bbc377043401d4a81d68a1cb74d99db65e4474d36782ca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d73de857fa0357279c4960e54e3b8d92169829457aafec7dddbe86ffc3681b4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3897b9520bced64992a3b99333883e781398f49b66afbf198cf09d96692cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34ba9a77fcf8c49efc02a92d8b6a70c1e609cf3f02c54bdd79bb8d57faa964cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5343c953d5db2d4cd0e79396c59fc1e74e4bbe4782f1d75ec7c953c8754f4405"
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

    generate_completions_from_executable(bin/"tdl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
