class TrzszSsh < Formula
  desc "Simple ssh client with trzsz ( trz / tsz ) support"
  homepage "https://trzsz.github.io/ssh"
  url "https://github.com/trzsz/trzsz-ssh/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "a6303fe52b2a67119293a6179c622117b39020f19f530bfad7437d7718575d11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3668f783da50a6a5b7c828d31effb7a880456b2a88494e4133a217f6ff1eafc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d261a0a0f57fe78a4f177921b50f11ce67ec4bb44d44b2a5a897c5757efdbdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b860fec7a3fcb1702b52863692fecaba6833957747a47597cc8c14b17bc104d"
    sha256 cellar: :any_skip_relocation, sonoma:         "332c3a1ca581c50c5ad3b47d1ad110586175ae04763929bcdce4cd9f2613e5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "beac3df3d841d312ddbb40b706ca541b44f22d69398748d8d3742d1231b56865"
    sha256 cellar: :any_skip_relocation, monterey:       "5457a23898896042b7467d19cf30baf9f1738122e87691d9306f7ba3c17a5254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1a5ecc8434c1c4c95e2616921fa6ade037e5c398813561de38cb4df6ef2fe5"
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
