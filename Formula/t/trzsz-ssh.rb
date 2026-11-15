class TrzszSsh < Formula
  desc "Highly OpenSSH-compatible client with extended features"
  homepage "https://trzsz.github.io/tssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "8655411ebe865b8d91463bc9ab336c14f8ff3eecf4889c3b2547e26559796b6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fc130fccfeb4067c4443c245ca52b9150e6cbfc4fde3c169a055a6cb0f5b854"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fc130fccfeb4067c4443c245ca52b9150e6cbfc4fde3c169a055a6cb0f5b854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fc130fccfeb4067c4443c245ca52b9150e6cbfc4fde3c169a055a6cb0f5b854"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3bfa84619e227d687691795e63c1f9fe4233e4e52cf652e8a8b445d013fa495a"
    sha256 cellar: :any,                 x86_64_linux:      "024848a2b47e0508b15d66fd14e5febc60d9c06bfbada548380c76edb5fec7e7"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tssh -v")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc 2>&1", 11)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz 2>&1", 11)
    assert_match "invalid forwarding specification", shell_output("#{bin}/tssh -L 123 2>&1", 11)
  end
end
