class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.2.0.tar.gz"
  sha256 "b5921dc3f3b446743e130d1ee39ab9ed2e256b001bd52cf410d30a0eb087f54e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aac8e5874ac87a67c2160119794b058d60a0f05e3a84879b414b8a581d8d7960"
    sha256 cellar: :any_skip_relocation, big_sur:       "eee6928c9a0910092cac7e40f898ac786680e665dc20eab1e9e6643c8bbefc24"
    sha256 cellar: :any_skip_relocation, catalina:      "b63db200f9b9303940cde9c64a588e27475fda08bb478f49451316c41d48d71f"
    sha256 cellar: :any_skip_relocation, mojave:        "b3b5ac68fde1afbb262eaad0cd10d21f8b78212de226a064f763a51444fbe5ba"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.versionString=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity",
      shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
