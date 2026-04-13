class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "c1a431addf696b7fb67d3c144c43293f3c4a7eb40096f7581e55e6525d76b2ea"
  license "Apache-2.0"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c0a6bfae29e084026e7fbe3601704dfc3a2065a8fba3dc586947b8112aaccc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0a6bfae29e084026e7fbe3601704dfc3a2065a8fba3dc586947b8112aaccc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0a6bfae29e084026e7fbe3601704dfc3a2065a8fba3dc586947b8112aaccc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f338c6e640114b1be1a11a574a0f470bed209fddd99149ec03e8b5bf02e46a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794aad91b7bb0b841222a55761135a408ee644b539eb49f99ffc6ad0bb7fd430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87965218774664c16237e22e34285d8a8539731a80e3e0a7628cc10f788ece7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenrumney/squealer/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/squealer"
    generate_completions_from_executable(bin/"squealer", shell_parameter_format: :cobra)
  end

  test do
    system "git", "clone", "https://github.com/owenrumney/woopsie.git"
    output = shell_output("#{bin}/squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end
