class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.0.22.tar.gz"
  sha256 "ed3be47421d1d269d6b16fc6affc64a86649e9b3de256c51cd97a94d75ed6482"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bc57e31a7bb269f1d71707378b822432cac46f7ae4fc193e9aadb5ab8a374fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e19620ecd2fea1ae0e1d86f9c90c94fceff19625f6d8fea5773fb7e96da85dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50c34bae83a3a400e2aafd397f8282218dcf3fcc2b1b8db788fb443268f477f0"
    sha256 cellar: :any_skip_relocation, ventura:        "cea8ddf7e4dcd9d4a7f486789e70755e34cfe2cfbb2be9a83a00c7fa87ed4bde"
    sha256 cellar: :any_skip_relocation, monterey:       "cfdedf9c2da8ef93ebe071d1aef1bca2b6bc8eb056842da3d9befe087233c2ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fed8b35c5045fc661a7899665b4b1c4e2e9e446352f229beddc31912021c6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947aa2a283379b9fce8120761a1cf1f2bbf1419c7bc36bcd00919ae3d8aaad81"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
