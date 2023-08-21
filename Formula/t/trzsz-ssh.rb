class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "783fc812bc16e52992c7053f3432b2a9ad285dbc854f88a510c671bbdd4c5c4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a74d8967e0013a0a6e8b47093c9c14df7470e43121285b7df42b39091c81b108"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8919ff8975bd2350b72f04e59f5227196df79dfc09390a548c6dfa9b4b354a15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edfef1a792229deb5ba743c83105099dc749199c2432626cd64241069f10d41d"
    sha256 cellar: :any_skip_relocation, ventura:        "16152b17c8c5976730c61bb866c7e19dbb8524169d201f7697051e515c2b3ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "7cfc5c7061762f4360ff066963e08128392f0c4ba1bc5bb2a73cbad4b8c5d03f"
    sha256 cellar: :any_skip_relocation, big_sur:        "73b103b97994b91838b5cad09605bff7bdf82b300668e78b511891ced5f240cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537eeea8e669608049988a42368ed0c36ac4396ea8618de6628ad4944ae73007"
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
