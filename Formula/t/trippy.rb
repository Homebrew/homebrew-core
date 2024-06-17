class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.10.0.tar.gz"
  sha256 "3dd15f6219b9b18da773c7af48e8bf35dec581975742ada5b3d930a1642a73d8"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94d0e4337ad2b2789c27706bd7d794946c66bc3d9107b711439d183cdf3889bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9b1375a41aadd51727978890690e8148f731663a1d60ced7ad04293f6f91df7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5ec6faf9c22e407da85a2e1e74cc7b47c5b0f15be6cd7bb8e12472d51ba1339"
    sha256 cellar: :any_skip_relocation, sonoma:         "8360b6300af514aba82a09d5b346132711bd1bd6605d861eff24286fa8fe5581"
    sha256 cellar: :any_skip_relocation, ventura:        "91dd4c75e182e9421efa9fc49f63da8c160c82f71b7073b581212eba11b82315"
    sha256 cellar: :any_skip_relocation, monterey:       "d4dc112315b997a9c1b83ad02fda511f0aa636f356ff93bdca096b85dbd32435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4061342b19b5ca0cfff66bac80187303e6d207abadd3f085c448d395d710d2b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}/trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
