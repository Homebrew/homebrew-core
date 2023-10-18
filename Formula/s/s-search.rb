class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.9.tar.gz"
  sha256 "7097264e7da0e7ac209e5be5e50f07f17593e2753607325870131af3000ccaf2"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2415bd6b75d1c94dd8db1a3e6ac9d8220097894041b90d8a880131b7cb1d5fdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5488fde11910aa31ad648aee0a11619635ac4a23fd83203ed09d6758c3c49ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ff75d3d38e1bc943b5004e0a16ba9f4567fc720a3a7337bcdba16cfdd4a696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c2470994cdd675013620b5c08efc04caea862380574e18566f69bae2aec590b"
    sha256 cellar: :any_skip_relocation, sonoma:         "8352a3e0684b8789413cd10ab1a0ebc7972b4668645066ce86de47f46b084843"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9f9c306426c63cda3939db31f05a39edccc0a0a5c4c0af38529ac66c279bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "41f416480327431717dab6599ba71f6cebe633be231bb11ca2212ef1822ba534"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9e5d0049f4ac8793386b0ada2a3b290e45b8af4872b26a3a778572a8562da7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8826754a88e741902c8c8f247aad3141ffe4cf7d9e7df3cff0d21d123fdb60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    generate_completions_from_executable(bin/"s", "--completion", base_name: "s")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
