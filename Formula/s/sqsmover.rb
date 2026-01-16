class Sqsmover < Formula
  desc "AWS SQS Message mover"
  homepage "https://github.com/mercury2269/sqsmover"
  url "https://github.com/mercury2269/sqsmover/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "217203f626399c67649f99af52eff6d6cdd9280ec5e2631e1de057e1bd0cdd0d"
  license "Apache-2.0"
  head "https://github.com/mercury2269/sqsmover.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "faceaa44808fd35b7d1131f1bda53f0390a814864185b8a16cb76d0531fd54af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "71138465799d2eef41934e3c9af64946ba7568d99b33c26b4f139bcba0957342"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc16a425c148319663c2ed049384633fb3402c86cb919f7274eeb01850416056"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed7f54467803a8b532f6980792beda2deed1943b905377386086b99b4343951a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8e6b9cc7c8df5f3bd6221092a8b90337e70afb21418b1ac386cbe6c1846dea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070d45a4448af507da69445d83084a38a8ba1d7ecad6d1d7596b2a5cba2d8b14"
    sha256 cellar: :any_skip_relocation, sonoma:         "062f576571aefdfd34b9e5eb773b537b0f8b129c165814a3fc4d3ca74d2217c9"
    sha256 cellar: :any_skip_relocation, ventura:        "8b8bde4ded805588395c80ab7ad1b9f99c722297c1c74fbede24739548216e3b"
    sha256 cellar: :any_skip_relocation, monterey:       "17d1bb2288e963f9f5e25bf91829c9ad24e72ae4630169002496255ab9514281"
    sha256 cellar: :any_skip_relocation, big_sur:        "e92a20b5b57e04747e869551f42d86bba14acb26c0ef88acf1a73f12429f43c3"
    sha256 cellar: :any_skip_relocation, catalina:       "964183c1530b7ec057849d57a9c63b188c2b5aab4f1bf3fe0db6073d4063c086"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2df5ac12c16115813738e4e198d711f296561be672730d6bb9802e8863d91b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d101d0f696e787fae56b2bf5ae24f85a64411b332fabc938fdd399377436b9e"
  end

  depends_on "go" => :build

  # Fix build with Go 1.18.
  # Remove with the next release.
  patch do
    url "https://github.com/mercury2269/sqsmover/commit/2791c1912e4e262dca981dcf2219305b3d0e784a.patch?full_index=1"
    sha256 "effd7cc9422b64944abada78cbd163c8900b3dd1254427cbdee76e106e8e540b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    assert_match "Failed to resolve source queue.",
      shell_output("#{bin}/sqsmover --source test-dlq --destination test --profile test 2>&1")

    assert_match version.to_s, shell_output("#{bin}/sqsmover --version 2>&1")
  end
end
