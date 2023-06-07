class Svlint < Formula
  desc "SystemVerilog linter"
  homepage "https://github.com/dalance/svlint"
  url "https://github.com/dalance/svlint/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "08294af18f775c81a0701e398d90e73d708f032c12baf575442ac4dc0cdd2d33"
  license "MIT"
  head "https://github.com/dalance/svlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "035767b125d505b10e1ab0e023b4b41105f9c32b75535029bb1c1bce48d62297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e993410a036ad95b402cc612fb758d3653cd52ea030d8c0c700bad56c5423a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c90fdef2123cb99cdf5ba30388c229416e027ba3398d43140076eef97a6090"
    sha256 cellar: :any_skip_relocation, ventura:        "eb9e9dcd845f01aed7c969b5cb3687fda9f4cd483ef4859c645d3f836d50b124"
    sha256 cellar: :any_skip_relocation, monterey:       "ffab7840054521d795475c6ddb3eba7d216c8cd2dd1a06e10ae490cf74adef81"
    sha256 cellar: :any_skip_relocation, big_sur:        "40b1cac1444d3e71c07fa0c56dbcd0b090628a7df8977c59a2ee2ee5fec27e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e104ad80c124b63a78238ca202f9d611e7c6446cf4cb8f67b601013f7a593c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module M;
      endmodule
    EOS

    assert_match(/hint\s+:\s+Begin `module` name with lowerCamelCase./, shell_output("#{bin}/svlint test.sv", 1))
  end
end
