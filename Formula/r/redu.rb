class Redu < Formula
  desc "Ncdu for your restic repository"
  homepage "https://github.com/drdo/redu"
  url "https://github.com/drdo/redu/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "09fda46231cf49663486a0f4a3ab0f217f39dc1f0ba1bcd05917e77e6f7447a2"
  license "MIT"
  head "https://github.com/drdo/redu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9341847b9b17a439df4166ef6b2ef3745eccc25dfa5be72f813aabb4e80c995"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d07ad03c7d9c40e09d6699215125761f5969cdc027eec24e08bfd3c1479dc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b11d6fb60a21c0de5b7728c0bba2646826941304e7939cb7df0a3748fce558cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "70fb244d3d565cbfbeddafa76a6ec75a4a69ae03521ae7270dc9f7f99a92cef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7eba457b049fa735e4900146fba93076def47a1cd5ccd7c05dc0b99d1bdc2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef1d2d80d9e01dcb597fcbf653afe6da0be7033bc2151ea145ab903bc1bd4dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redu --version")
    assert_match "Error: restic error", shell_output("#{bin}/redu --repo mock_repo mock_pw 2>&1", 1)
  end
end
