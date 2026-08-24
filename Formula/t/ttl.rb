class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "bbc26008b9ee2879a08b0262016522e795c0c80c0f34f1936b5715536cca3358"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3eeca4a62eac597cd48aa855ad4dc334b0953d46771a8764677a175f1d1f035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e41d1a097daceee7c5d1d422a668b23eb63b28a4705ec3be457cd24be9df6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b994249da7b0644d1883bcc0158f308190c6fa0c92b1a66824cd8767231c9ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe56f8d47ca7c3b501d5591834797cdac08006fbe7702c5d26173e9b8291c3f"
    sha256 cellar: :any,                 arm64_linux:   "fcd4afbfe9388e44c134090226c4c528312f6743f7f127e6427e237c2cd53867"
    sha256 cellar: :any,                 x86_64_linux:  "d23fe859e59b74864177e9362e37b4b8b6917a983a2b07da53077936cc948fc1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end
