class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.23.tar.gz"
  sha256 "e4fa0f6f443faede83380ceca4a0de862c054f37c27983a7bbe6bced1d9f80da"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5366a0fc68e55f86518f33296a6594c11d8ce788b283badfd869ee787615a8d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5366a0fc68e55f86518f33296a6594c11d8ce788b283badfd869ee787615a8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5366a0fc68e55f86518f33296a6594c11d8ce788b283badfd869ee787615a8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49a6e4f5145e57aeafbec67bf1f200393b64e931af6906e1c940bade7941f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52121142aa23b88a5f98b2c2980a428bc00c837bc46dfa14829f90798cc44b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3502362a3dc731febbb45ff0cd6b1b1228424fc7dbad0307695b237ad1f0358"
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
