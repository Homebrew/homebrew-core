class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "5230a9fec7bee668f5c069bb4ab7401844d16426d8954cd95d138e2c1331c22e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "29117d2a2c1b7b34bc3c29851d1cca1cda40b19af17c1d289080698728d8d8de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "feafbea73109a1318a247f7156d3ef30df30a622b1d41903b0fe96aa8c20457d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bc4041a159932504d276de3f647c07cf86c060dc05d03c2eb7e1a14380ff29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a66c827258c777803d3f7d5df5a4ba50f52b00b022c37f2438f1fae15b29790c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cb678905f2c6a026e1b7512e196d1478334c4b1129c949e4fb98762f1d1a87f"
    sha256 cellar: :any_skip_relocation, ventura:        "850de5319efc8a954315d5125c5c2682bd13f41a5f8cfa36b9f6d05a52c14d39"
    sha256 cellar: :any_skip_relocation, monterey:       "0134ac63beb54873d3c01da1b58e408e994145718fdb0f7cdb1e52f4241ef60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f64a6b6b8620e2cdb18b0d5db059748d21df1af61989f0a1ac226170cda753"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    testdata = testpath/"seq"
    testdata.write(1.upto(3).to_a.join("\n"))
    testcmd = "rust-parallel -i #{testdata} echo"
    testset = Array.new(10) { pipe_output(testcmd) }
    refute_equal testset.size, testset.uniq.size
  end
end
