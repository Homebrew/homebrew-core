class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "c5de99390846029aacb23789ce20267142dc89f647c519a0a0bb4821334cc6e5"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1beb0eaca9c6e843f291dd98b759f5d37f51b1f966bdf44f1eaa6b0de5a6cf38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44bb25f77068c5d9f414704f4855608a92d43924682a4f82d4448dd29155d2a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "566a1614459cab699a7404e731d5b15087de504008e2f3896a088292b679078a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe934b5d579ce7e21fb51a261d53b991cd72d5f4f70af27ed17f0ba5951464f7"
    sha256 cellar: :any,                 arm64_linux:   "f17083987844a04491c80a50a55fb50b2cf719c8501b9d3695bf2c33f872b255"
    sha256 cellar: :any,                 x86_64_linux:  "bfbb113c020b82dd894965fe3ddd9641a72b68ed178015c7f3d9572a4de1b0b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    begin
      pid = spawn bin/"viddy", "--interval", "1", "date"
      sleep 2
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}/viddy --version")
  end
end
