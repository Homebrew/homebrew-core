class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/v0.4.3.tar.gz"
  sha256 "3f32a438226287d80ae86509964d7767c2002952c95da03501beb882cae22d2d"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fc1ecafec88eae6a750b9813084c58cedffbf15cfa8a5c1c4d8223783f9b410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f63431f0038bac796d94604322236db7f31b15759ccf3b1874597dc215a74ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd91dc84b16cc8c51e243b6808f428e94ff4ba2b63165e7adf5563b5b1f9171c"
    sha256 cellar: :any_skip_relocation, ventura:        "ba21a9519a354aa85fc24bfcb6bed7233ce46d2194e28d9bf49062ded1e0057d"
    sha256 cellar: :any_skip_relocation, monterey:       "a93d3617f3167e69b45961b876ea5ea4dfbc60b080d143e2ca95870089cb24ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "7052eff293193940046fd1dc13c439fa81fcca5e1d7b71d9ea81e060f31284bd"
    sha256 cellar: :any_skip_relocation, catalina:       "b55c620a9eae179704c06f4cbb6421b6a4dc8fe4ffe6771f1e15d538ec0eaf92"
    sha256 cellar: :any_skip_relocation, mojave:         "14bf33c09c8b65c74004b2ac8bb036a342d191ccaf8b1d54d9795d13f3cf6fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20f8338fedd79014c80a96c9e3ec990454be276fe98dcb112c169b13a7f0cf2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end
