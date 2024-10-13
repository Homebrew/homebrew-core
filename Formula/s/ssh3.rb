class Ssh3 < Formula
  desc "Faster and richer secure shell using HTTP/3"
  homepage "https://github.com/francoismichel/ssh3"
  url "https://github.com/francoismichel/ssh3.git",
      tag:      "v0.1.7",
      revision: "31f8242cf30b675c25b981b862f36e73f9fa1d9d"
  license "Apache-2.0"
  head "https://github.com/francoismichel/ssh3.git",
       branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0f4b007d021b93cfb0c17d853b9ad0f8e8d9112402a7acbbb466f90517e20a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1738b1f0a7e8d6b101de0c28c854a885cff32e44a3cf1296fcdb3a411950879"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "356b85de8658e16ee74a1c86abd3be1491c61b09cb4634ae39fd49c9ec008d76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cba01524ab567c3e2c65463a10e87841b917ce6bb16a90256235453890bebbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b59edc9f47796dcbf9009dd3e862e5558e21cfe78b8260cb0a6e5d519632e865"
    sha256 cellar: :any_skip_relocation, ventura:        "fd05c0f9fc69ee952285dbdd8becacfc88fc69fb06aeb705035906fc166dad5e"
    sha256 cellar: :any_skip_relocation, monterey:       "994b1e63734368f14718507f653b797d99cc472c22482f8cb68a86165ffeab21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a55c20f0e83d74d05032b6e832bcd761d6377a226183e99d4102c1ad66935a"
  end

  depends_on "go" => :build
  uses_from_macos "libxcrypt"

  def install
    system "go", "build",
           *std_go_args(output: bin/"ssh3", ldflags: "-s -w"),
           "cmd/ssh3/main.go"
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
           *std_go_args(output: bin/"ssh3-server", ldflags: "-s -w"),
           "cmd/ssh3-server/main.go"
  end

  test do
    system bin/"ssh3-server",
           "-generate-selfsigned-cert",
           "-key", "test.key",
           "-cert", "test.pem"
    assert_predicate testpath/"test.key", :exist?
    assert_predicate testpath/"test.pem", :exist?
  end
end
