class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "26ffb34240cc273eb7d0f3b6ee5a9a124c7c4a947f39fb22877ca2f93a539d73"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "582ac02e93cf2640274cc8f5112cbdce320688cf9d5b4897c187d8761778746a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4bb478f3f2aded8964b8477064e0c8ea6806f65b32582a7a6dc9e119185e22a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c9e0f437479d5b01106efa8e7632e678e68fb60eaa47c45557d7092dfdcee80"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49069e36cb6e4ab7daeadfd77ef675dc5a150fa78aeb020562f33820ca13e0d7"
    sha256 cellar: :any,                 x86_64_linux:      "69ea7f61a1dbb4fb6259a51038d93400e882fa4e36ea5ffb23e393806e3057b5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
