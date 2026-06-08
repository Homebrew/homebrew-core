class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cfc51a5c0e64888b7ec81f98df4138cf96ea63f67696d915dbd47e0ae1303d10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0fca29c1a10577937fbd95bdd8c3c08d14c0a6f0f7f273aafc68fa022f825c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0fca29c1a10577937fbd95bdd8c3c08d14c0a6f0f7f273aafc68fa022f825c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0fca29c1a10577937fbd95bdd8c3c08d14c0a6f0f7f273aafc68fa022f825c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6e65c14e8e9d97671f1bf268b9365e91e28de9cfcb82612c9426f584a75b044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a40d7610c71e020ecdff5c50c164a2c0bd49b9dd8a9d5731ef1ce3b4dd402b"
    sha256 cellar: :any,                 x86_64_linux:  "2b90947cb7f46442f103555ee250430436ceabc8063053d349bbf21024f445c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
    generate_completions_from_executable(bin/"tldx", shell_parameter_format: :cobra)
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
