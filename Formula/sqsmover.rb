class Sqsmover < Formula
  desc "AWS SQS Message mover"
  homepage "https://github.com/mercury2269/sqsmover"
  url "https://github.com/mercury2269/sqsmover/archive/v0.4.0.tar.gz"
  sha256 "217203f626399c67649f99af52eff6d6cdd9280ec5e2631e1de057e1bd0cdd0d"
  license "Apache-2.0"
  head "https://github.com/mercury2269/sqsmover.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8e6b9cc7c8df5f3bd6221092a8b90337e70afb21418b1ac386cbe6c1846dea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "070d45a4448af507da69445d83084a38a8ba1d7ecad6d1d7596b2a5cba2d8b14"
    sha256 cellar: :any_skip_relocation, monterey:       "17d1bb2288e963f9f5e25bf91829c9ad24e72ae4630169002496255ab9514281"
    sha256 cellar: :any_skip_relocation, big_sur:        "e92a20b5b57e04747e869551f42d86bba14acb26c0ef88acf1a73f12429f43c3"
    sha256 cellar: :any_skip_relocation, catalina:       "964183c1530b7ec057849d57a9c63b188c2b5aab4f1bf3fe0db6073d4063c086"
    sha256 cellar: :any_skip_relocation, mojave:         "0874e450ddbdfa8b1a4d364ed7467a50d7f79d90ae33e0a147c3f291b055d20e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    assert_match "Failed to resolve source queue.",
      shell_output("#{bin}/sqsmover --source test-dlq --destination test --profile test 2>&1")

    assert_match version.to_s, shell_output("#{bin}/sqsmover --version 2>&1")
  end
end
