class TrzszSsh < Formula
  desc "Highly OpenSSH-compatible client with extended features"
  homepage "https://trzsz.github.io/tssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "9a692854733333643b6108f68bed0239b266c461e15125781503d957c9b47842"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d78c3aeb716de54f2eddb73c3299ff4fae02a079f87250a96ef683b8d9f0778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d78c3aeb716de54f2eddb73c3299ff4fae02a079f87250a96ef683b8d9f0778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d78c3aeb716de54f2eddb73c3299ff4fae02a079f87250a96ef683b8d9f0778"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c333aaec33670a97e7a1773f9e783c617e46207f7413ebdb8604f7c8b38541"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df41555cba2702c68478592972f6b589ebb6d1b599cef82d7f13145baf268e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7f91c7455f1af3c84e9b7206c8e49fe97014854ec83b2c2ed44d5b90169559f"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tssh -v")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc 2>&1", 11)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz 2>&1", 11)
    assert_match "invalid forwarding specification", shell_output("#{bin}/tssh -L 123 2>&1", 11)
  end
end
