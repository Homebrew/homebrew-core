class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "1502ffc9bba859ad1704a55bfe145288c9d5dc7dfd5c7ded0de72d930dec7346"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e63b0886ee72c7cb5476f8e921bc35311795c97f707b660f7cf7c5610d4875b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79e6f208b6c7b4dbd6bcbbe8843f0f1501a0470b688b892f2018fbd3a9d57dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70df2aaf3dbdc9f95aefc5d4c96f4dece9049b06a9919153594bdb9aea7c3077"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d030cae78135d83e9abb086b729673ddf9b3324e3e1ce1effd3812477316c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b327e6b47147ca4446d01221616980ebc4d295fda341b7218048dcf14b23661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b046b5a91568e7aa70002291406f05f5d60f8b9d6f3b78c5482a3c06cb746b94"
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
