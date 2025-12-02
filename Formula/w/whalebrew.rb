class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew/archive/refs/tags/0.5.0.tar.gz"
  sha256 "2abea4171dbdca429b6476cffdfe7c94ce27028dc5d96e0f3a9a4fdeab77c4fb"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b125f806242ba20dc7c14b14a23467cf59e022911036674f33a540aad35af8b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b125f806242ba20dc7c14b14a23467cf59e022911036674f33a540aad35af8b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b125f806242ba20dc7c14b14a23467cf59e022911036674f33a540aad35af8b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "132b42892e11feae8f7498c190024daf51ea29f7dcb9480b8a67e2fe6989db94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "812e1faaafe66a26fd5c72c52659f11f46968a588d7afef73d133a6b79964dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85863cd113b47cc45953fcb9eb928710e08eae63290ed8a09678cdfa8c89a23f"
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
    generate_completions_from_executable(bin/"whalebrew", "completion")
  end

  test do
    assert_match "Whalebrew #{version}+homebrew", shell_output("#{bin}/whalebrew version")
    assert_match "whalebrew/whalesay", shell_output("#{bin}/whalebrew search whalesay")

    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y 2>&1", 255)
    assert_match(/failed to connect to the docker API|permission denied/, output)
  end
end
