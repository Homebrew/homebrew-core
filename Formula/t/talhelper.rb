class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "28a91243315adad48315f3403905d83f064ed1602cb4cbbba1227b8921704e03"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9f9575fdc58502d69c13f0ea19ed5187ebbf3f2dddfd9240dc4a57c4e053c6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e57faa7e54a754b6255315f309d1d29040504a060322ed63848915bb7e59ba83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb37b2963b0e15f9e282f5e190a1b93a8a3d01869c8b1a0e2248ba182aa22f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "afaa2c3a95f29a24eca6f923f274cf518620716f817ad73e4ea15c6c9ed76b67"
    sha256 cellar: :any_skip_relocation, ventura:        "a6101a752619b90eb64fc6ceb714ce32f6d3ef6e961071fb988d52f693183242"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f88c7db60d858592b56dae76344e5501ac1f9ef8fbc5b2cbdb8d57db11381b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac411bb46dfc64d158e41b709283fee28b7b0a2fd0991d67adacf7e62e06222"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
