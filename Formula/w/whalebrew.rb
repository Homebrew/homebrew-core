class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew/archive/refs/tags/0.5.0.tar.gz"
  sha256 "2abea4171dbdca429b6476cffdfe7c94ce27028dc5d96e0f3a9a4fdeab77c4fb"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f6830e7d52fc290dc2436ff9c6284990599dcb4c0425ea5f88e7010e0e6e40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f6830e7d52fc290dc2436ff9c6284990599dcb4c0425ea5f88e7010e0e6e40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f6830e7d52fc290dc2436ff9c6284990599dcb4c0425ea5f88e7010e0e6e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "37d1cce1732c129b95ecb9802c4e59cf6d404407835d545f0d5019387e0ef37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d87aaaf730a6451d6442f3caa38545e5bb3ed6779926d712ea111823d26f3058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0143e7491195c0620ed7a492aab85c01fbe901849955acc5278a23d224b01550"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  # Run "go mod tidy": https://github.com/whalebrew/whalebrew/pull/299
  patch do
    url "https://github.com/whalebrew/whalebrew/commit/f64b9db9a5f1c91571a622a58eb93233f8c59642.patch?full_index=1"
    sha256 "62d5cb208d60ed123a5be234a1c3d48aeead703a83eb262408a101aec66bd0d6"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/whalebrew/whalebrew/version.Version=#{version}+homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"whalebrew", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Whalebrew #{version}+homebrew", shell_output("#{bin}/whalebrew version")
    assert_match "whalebrew/whalesay", shell_output("#{bin}/whalebrew search whalesay")

    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y 2>&1", 255)
    assert_match(/failed to connect to the docker API|permission denied/, output)
  end
end
