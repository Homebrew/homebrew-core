class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.12.0.tar.gz"
  sha256 "4baf5e9f4d4490148ca739af6dbf5234c79dc5f8882690575ade29ce7f9b60e8"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ed6abadc13f3ebb6df001aaab3cfe4d04f6c34d47ae74bdb6dbb2f6394d4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652a8cf4bba73302c1e717071677393bb882c791ff9c18da466a4b156126c6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5080deef349889e07a30eaad660424af92d14b737957a342563d097b2ba6575"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e03e321dde8ed24c82c395bebce9ca24455c815df5e68ea53fe896fec8e1631"
    sha256 cellar: :any_skip_relocation, ventura:       "ed80b25cfae42930a318022cda6f765d3b73132ee2b1854afa287bae4a406d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e9dd4e788e412388cb2e1e2cf5bb2e476595b08bb19e319ea3884837f7efd76"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/trippy")

    generate_completions_from_executable(bin/"trip", "--generate", base_name: "trip")
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = "Error: privileges are required"
    output = shell_output("#{bin}/trip brew.sh 2>&1", 1)
    assert_match expected, output

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
