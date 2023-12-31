class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://github.com/iyear/tdl/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "80d58805d8c138280a40fbaaa3b3c5e07503c33b67da61fc4bd1523416d6dd2f"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c461ef91081d47e53ce80159bede206d4d576ae895fef668313aa68087a3554"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dddbf523dd803c84a2370a0b596acbcb841aef46a44f8b52af1a602944f988f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c43dc03d5b8952c8827035ad1c6a3a50f8c729b9146e7ca506326872cd25c949"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcdc5c9b2e608e1408f0b27567ea35d45182ccee5813470318260c6335bb6d32"
    sha256 cellar: :any_skip_relocation, ventura:        "962603c407c97a8b493d59a10d0bb2b58128a3090c863f9e8ed3ac2e370bd063"
    sha256 cellar: :any_skip_relocation, monterey:       "560817f2ddc2f7b19f8496768d66dd36e2f1863faabcf839939d5b7d61ad62f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2bebf45604feb5e77db2ce2996edcd0977ae756e105bb2781f42f664323eae"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
