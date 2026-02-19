class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "f95bfa6f03a465d7862ac3a49461dc6f24ae379e4a81153975e51e08af6ff4d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda3926698fe171974b679a75ab02967c7298ded2923ddfb70ce82fbc8d8e39a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d7f6ad2ceb0af6480d98b2f2107be480a93e711b25cbab3066093878dbd65f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0383b101bd33da0e184dae3a777207769c0215a3795e70e4db8d8d1499989b90"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec7ca2b3e13ac11dc140370420d99a709973207eb38d073d05115dcc1c88dbe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84e465d86c24d3035ee5437a55528a5b2e0d97a6d7da451e068d736d2884b97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b792b938f6ca503f648def594733191407140f956371bcee8b99aa41d1491741"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end
