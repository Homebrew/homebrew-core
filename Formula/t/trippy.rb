class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.13.0.tar.gz"
  sha256 "72e598d2e0b947e8bc46706021c511f169b7e7634a734c326e492e0f30725c35"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b6f631c8a293fc7afa5b9f2752bb95b46beef7ee132d185c4e2a7b13caf570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa029604d2f1edc732e6c8fd9ccebe1e1c1d1b230b5fa2a176aa0fed0eb00aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18d09726f789d0018dbc2bad3b2e3113e218bd83c1925cde652c2659d2e5a7ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cac5f223c373ab5e005d9f8d7cd83d4b592c1b0f9654ee900b5fce957d12e914"
    sha256 cellar: :any_skip_relocation, sonoma:        "488a25a98d18e87bc3ffcacc8e22f2f1cb8c087bb714dfef5a20fb4a6df3e8ba"
    sha256 cellar: :any_skip_relocation, ventura:       "3fee54d51f08db8f3768ccc174fd827e0aa650c1634a7ffccb5208aa97a5742e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36282bf41fbc68b6fdb67dc6dd604573d24d2a3805db6c1d500a9d3d12428334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67898cd0f8db4cf94b36fdd02b59434b2f8092d4a0d31f9608202ef67fd62a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/trippy")

    generate_completions_from_executable(bin/"trip", "--generate")
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}/trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
