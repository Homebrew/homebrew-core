class Uptoc < Formula
  desc "Convenient static file deployment tool that supports multiple platforms"
  homepage "https://github.com/bonaysoft/uptoc"
  url "https://github.com/bonaysoft/uptoc.git",
      tag:      "v1.4.3",
      revision: "30266b490379c816fc08ca3670fd96808214b24c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a3d7a5541827372a2aae8b7feafc0f335b732fd0697fb2cf1bd608c493b53662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "08d4c187e6b815cf9700234440df6fee4b43a1b434f849b0a198df53b7643c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6af1eb82ab71a0b60e91a89799ae844a36b8c5744c34aa3995d138551e057ffd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "942cacc0ae14be9ca4c89497326c0c2d2a80dd9387489ba12de73da0fd98cb62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09100a8e6f85e66cd71378e628bc57cf200f224750a000be31b6bef6be1a1ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e6500f982ce6d54888461d97c8bad6dda039d065e883a60047ca549d9e06329"
    sha256 cellar: :any_skip_relocation, sonoma:         "898327e594c1901b920946634905310b4249f00d7d1e8a7aab3dd14e694785ec"
    sha256 cellar: :any_skip_relocation, ventura:        "cc771d7e3dd47f766d7a7e9fd76a9c5b25367f2f6f2ddafc2ab1c5a08fb5db7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e9d53160af121806f4eed752935163d9ffc17b84ec42afeedec7eafb8c1bc0a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "40353c235e30210ab737684f85d6c444b580192eccbf50d84fbae0fa8a64c27b"
    sha256 cellar: :any_skip_relocation, catalina:       "7a2f3982a14ad4176b17832e87dfb2a41fd10d87e0e35ade341b8baa17d3b7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "423e183833efc41df40c270119843aa9eba45be0dc56187bebc095ca911721db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac376a91915fef295b2fc42dcc20591f5fc63246308ffe11d920a9ecf6ae59dc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.release=#{version} -X main.commit=#{Utils.git_head} -X main.repo=#{stable.url}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uptoc -v 2>&1")
    assert_match "uptoc config", shell_output("#{bin}/uptoc ./abc 2>&1", 1)
  end
end
