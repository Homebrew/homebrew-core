class Ssh3 < Formula
  desc "Faster and richer secure shell using HTTP/3"
  homepage "https://github.com/francoismichel/ssh3"
  url "https://github.com/francoismichel/ssh3/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "23a88d0d7f54f80d752c22ee5f879fa1daf8c320ece364287209c58b3e98b6b5"
  license "Apache-2.0"
  head "https://github.com/francoismichel/ssh3.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f4c9c05fd2c4cbaa2a0d9bfafbc7e0a8b7b2bd4e40cca873bf8d6154d1502520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0f4b007d021b93cfb0c17d853b9ad0f8e8d9112402a7acbbb466f90517e20a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1738b1f0a7e8d6b101de0c28c854a885cff32e44a3cf1296fcdb3a411950879"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "356b85de8658e16ee74a1c86abd3be1491c61b09cb4634ae39fd49c9ec008d76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cba01524ab567c3e2c65463a10e87841b917ce6bb16a90256235453890bebbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b59edc9f47796dcbf9009dd3e862e5558e21cfe78b8260cb0a6e5d519632e865"
    sha256 cellar: :any_skip_relocation, ventura:        "fd05c0f9fc69ee952285dbdd8becacfc88fc69fb06aeb705035906fc166dad5e"
    sha256 cellar: :any_skip_relocation, monterey:       "994b1e63734368f14718507f653b797d99cc472c22482f8cb68a86165ffeab21"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f5d55521952438ac8b31391476252c88f70bb6d59e3d978c86c2287a9bf46825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a55c20f0e83d74d05032b6e832bcd761d6377a226183e99d4102c1ad66935a"
  end

  depends_on "go" => :build
  uses_from_macos "libxcrypt"

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ssh3"), "./cmd/ssh3"
    system "go", "build", *std_go_args(ldflags:, output: bin/"ssh3-server"), "./cmd/ssh3-server"
  end

  test do
    system bin/"ssh3-server",
           "-generate-selfsigned-cert",
           "-key", "test.key",
           "-cert", "test.pem"
    assert_path_exists testpath/"test.key"
    assert_path_exists testpath/"test.pem"
  end
end
