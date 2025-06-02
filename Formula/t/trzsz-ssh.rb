class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.22.tar.gz"
  sha256 "ccf5a113d68156b409d89fead784256b4fd6a6bbae6a2d70df1e4403d383a962"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e6b2a6b5b2c89403d127d93f50dc18f1e91472c94353530de7378330e7933dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5492415379fbd7159f38b5075842a3662cabd815e77e7abc77f4bc67d39a14c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5492415379fbd7159f38b5075842a3662cabd815e77e7abc77f4bc67d39a14c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5492415379fbd7159f38b5075842a3662cabd815e77e7abc77f4bc67d39a14c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f69d82fa4beb36e67df26a299536e170b980e8671e980c14cf532448055f4114"
    sha256 cellar: :any_skip_relocation, ventura:        "f69d82fa4beb36e67df26a299536e170b980e8671e980c14cf532448055f4114"
    sha256 cellar: :any_skip_relocation, monterey:       "f69d82fa4beb36e67df26a299536e170b980e8671e980c14cf532448055f4114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834702bbebecfa8ceb019bf703ac0d3c041e06f7ef78e10c0e3271fa53c07c8a"
  end

  depends_on "go" => :build

  conflicts_with "tssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V 2>&1")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version 2>&1")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc 2>&1", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz 2>&1", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123 2>&1", 255)
  end
end
