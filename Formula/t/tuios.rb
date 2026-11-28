class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "26ffb34240cc273eb7d0f3b6ee5a9a124c7c4a947f39fb22877ca2f93a539d73"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    manifest_sha256 "6deba7e41ee0ea51f4abb7bd8391365419beb124f6acee590394b1a6ac5bccaa"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f5c4ce89d00e42edf78401fcd6bc0fcd6ea6f7b8c423b864e429618cd603615"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "beffbd548dfc11b0e5ebbb420db9e5c720bf1367bdcf1656a6ea928e5dbd91ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f76cf206b307791d48638769e1b468839d03211249b65bedb4b8c11b0195f34b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b19265ef329dc75acb570d1a787cfec726cc4ccfaeaf0ac87bc49767784aa49b"
    sha256 cellar: :any,                 x86_64_linux:      "105966aea7918bab73553ebb162e2e5ea630739cfcd0be7a2b747b3138320a6a"
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
