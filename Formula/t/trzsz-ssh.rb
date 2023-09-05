class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1e11ffefd5021996bf1bcbc9b84b644a48ea7ef2262acece2f373f0795e48c35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d6f50f406455b5859a7dfb9e246684fc46299c34a70057675eeb39c9dc2beec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7199aae0cc11edecc9c1aff0c3b1ba622a20203838bc87a13a86018935b754e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "431f6b1cde494c494aaed50daf5c28fefbae7636f9f983ac7f6386f00fbcdc62"
    sha256 cellar: :any_skip_relocation, ventura:        "70b7b95250d6d5dba79c96b83b2cb7eb33c22080de8206577a347f3bccfc454c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd2bc73958945bfab0f6d71d130b72d4388d0aae46b474aaa3e2c05a0f179f8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "21a23642ddbfac93eefbaef6902c805a627910a58f2a7e250b489b5d8b901562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43ac2536dfac843b88726bf3dabf3b6951b64cd41320075a0dcf23209000e9b"
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
