class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.9.tar.gz"
  sha256 "04cfac019e2820ac2e7407f9ccedd5bcf1b6354784592de5d1f21bcda6f5f9ae"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fedc143dfbd40b50222094ecda3b39df84e28321761821829b1a7aaf3b902c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fedc143dfbd40b50222094ecda3b39df84e28321761821829b1a7aaf3b902c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fedc143dfbd40b50222094ecda3b39df84e28321761821829b1a7aaf3b902c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dfe776187098e03dffa29e1bcdeb45b1e83ac04c233bbe3271042602355d136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c60e5cbd734ec2b18d7208944d2afe3395983797df62aa10e586f32c5a9563ba"
    sha256 cellar: :any,                 x86_64_linux:  "62f261f29e90c312e16bd793f22075d33beab6b2065ba24e60c89fd043ef71ff"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
