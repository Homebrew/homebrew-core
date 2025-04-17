class TpchgenCli < Formula
  desc "TPC-H benchmark data generation in pure Rust"
  homepage "https://github.com/clflushopt/tpchgen-rs"
  url "https://github.com/clflushopt/tpchgen-rs/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fdb01ec6ffd426de928c4da5e33945095560c78d1b35eaab09f5d4c8c4aa7cb9"
  license "Apache-2.0"
  head "https://github.com/clflushopt/tpchgen-rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tpchgen-cli")
  end

  test do
    line_count = shell_output("#{bin}/tpchgen-cli -s 0.01 -T lineitem -p 100 --part 1 --stdout | wc -l").to_i
    assert line_count.positive?, "Expected some output lines from tpchgen-cli"
  end
end
