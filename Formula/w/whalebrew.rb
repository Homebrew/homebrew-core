class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew/archive/refs/tags/0.5.0.tar.gz"
  sha256 "2abea4171dbdca429b6476cffdfe7c94ce27028dc5d96e0f3a9a4fdeab77c4fb"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "301d2f38ace71c39fa8acff98d09b240b469a64c71e0a2105f0632ca2795b950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b20f0a59b4ddca952293210217096767bbf3641eeaf8a20d783479ec2d23029"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b9a806bb5c88d5074e037c34d4f1070b24a3c709a6c12997c256a68c12eaf44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3afe9d7ab8ff22f8e394da65c9f58bc4b495dd758a19c27a6d0b5961f017885"
    sha256 cellar: :any_skip_relocation, sonoma:         "e73f77883a8b321bcebdf5829211ae1d62c89633d760ec77cdfee6010665b681"
    sha256 cellar: :any_skip_relocation, ventura:        "0cf1db6078f81c0139448aa53137190bb3396da6b1645632b04031e102d141e3"
    sha256 cellar: :any_skip_relocation, monterey:       "ed592d731941336ccb5c3200f54e4557af185839a883dbe38f3882eb8e7f34b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe4b4c69e9b76da440101b3fc26cf623bf391ba23d1e5d64394f770a7776b86"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  # Run "go mod tidy": https://github.com/whalebrew/whalebrew/pull/299
  patch do
    url "https://github.com/whalebrew/whalebrew/commit/f64b9db9a5f1c91571a622a58eb93233f8c59642.patch?full_index=1"
    sha256 "62d5cb208d60ed123a5be234a1c3d48aeead703a83eb262408a101aec66bd0d6"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/whalebrew/whalebrew/version.Version=#{version}+homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"whalebrew", "completion")
  end

  test do
    assert_match "Whalebrew #{version}+homebrew", shell_output("#{bin}/whalebrew version")
    assert_match "whalebrew/whalesay", shell_output("#{bin}/whalebrew search whalesay")

    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y 2>&1", 255)
    assert_match(/connect to the Docker daemon|operation not permitted/, output)
  end
end
