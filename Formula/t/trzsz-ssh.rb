class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "6db0b151caa6a914352835fba3c3d0ff8fbfbb6b37a1309de09aeb3cb3802d27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d6d99904359bd21d18ed710117bcc179923a9116ed929686b297de9119bf09f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dc2c782775ea45c27c3b8656dce0f0539cd19037439a6a50d69a826ee5b7018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b6fbd903107d2245f9b8a976cfce862eda7a6c1e7b3d7d3806a9eba785db6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "07fb83e48bf7837b7c1fd79957c05e62fad94b5e9c3ba2c7087de708b69b2123"
    sha256 cellar: :any_skip_relocation, ventura:        "d00813fb46ae9712fbccd72dead27e0f86cad27f58da92a7fb2b2ac3f0e497ea"
    sha256 cellar: :any_skip_relocation, monterey:       "4e4a31aa8471126fda0ee1cd9a09cb0815597f7d885abf08784e1b52640c4da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c420334da9be507cb57658791aced619a8273b90d45db4084268e7ca41364e8a"
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
