class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "c07415b21f1d78b712e4db832663fcf96a54311cd13ee0bb9d7a277d6f6d2d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "688b9f326cc47b9ad9786315d90af4ef26ea5937a4970a0072db1e24e8a1ca8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e852cea9f2cab4ddffa0b6032eb0aac84df5a853f4294acaf321508c6d2ff038"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e6a8d0f84c29a1ca3c10e276763ad0031f04020e18ddd0c03585c749192d8c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "55575f9a997d4f21114a36a33eebf9cb6e02b3c6f40a01580d765c5c67c1e024"
    sha256 cellar: :any_skip_relocation, ventura:       "570f5c357013f0aca0dbeb771d845c785e83f0700534c58b6d4898607eac78a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a82d0210c52e20ae17410612a2fd2c4d92b319ea4f0bd3fc7204181954168a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5065834bac8970ce57802ba1e09988f4e5c191ec72a8d8a159ef8f10c92c5d4f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
