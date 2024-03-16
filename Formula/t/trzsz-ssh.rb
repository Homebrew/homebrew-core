class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "6db0b151caa6a914352835fba3c3d0ff8fbfbb6b37a1309de09aeb3cb3802d27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8995756f5c6eb83c57a58033041cdd1af7cb60cd470aa807780e080b10ff5a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31998f79d38ca69a900e22183b1ba25bc12738a170c780a21a468dc6cd43df28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf06c0d00e134519911c8dc16e8fee9d97455fabf786666655f69b0c69984d4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e3a4f64b833c85413d05148eaa8ed1b31d369a7eb0c9f9730ea33110f367595"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf201675a2b685a78b386d58e96debeab56aa23933ccf58ea78b56797cd36c3"
    sha256 cellar: :any_skip_relocation, monterey:       "e367b7ded747be8809ca2b3996ef6a14a7d953f0a84f0bc5cabcf057dc7d8093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "041a11b0f71d2726677b66b669937cc843186235293bd6e92148468c19680921"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tssh"), "./cmd/tssh"
  end

  test do
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh -V")
    assert_match "trzsz ssh #{version}", shell_output("#{bin}/tssh --version")

    assert_match "invalid option", shell_output("#{bin}/tssh -o abc", 255)
    assert_match "invalid bind specification", shell_output("#{bin}/tssh -D xyz", 255)
    assert_match "invalid forward specification", shell_output("#{bin}/tssh -L 123", 255)
  end
end
