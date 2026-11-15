class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "4d0c54429f166c31aaef96b9c70a8fc90ed19963e3cc0f2f832abec8ee751fcd"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fe5724023917cd14f2fac587731c9e5340c6e59ec717e69828c59eeb198ea1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e93787d3df711e7f6614daf1923f5e0434450380b0563f44a4e63bf26526a4ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3012237959e6845db3d26c598524514df1ae3810b297ce010593149961c97e10"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a31f4dd2de14f3c80dbe665a3abc1f3012583836ffb449099405955ef0f0cf14"
    sha256 cellar: :any,                 x86_64_linux:      "e9fb114a3ff5d80645bbd462ac3b962c301e98d2ddbbeca3a3a8451835f4388d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
