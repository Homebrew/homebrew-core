class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "242a9c6c9d744a0724950a4ef7197991f5ff8e90a4b870ff1f0a03798a4b9433"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff077d989b5333bf9d21d59949d7b8364b7bc9fcbf26b4f8fbc7575834427af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcbd6825a461f0fb10382e7931ac96ba183e32b2b409d3e5d07e93c694ac2723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76220f1c40479ba8d14dfe9ede1e3238c0c9a3460f6656c8538d05fa3133dc2d"
    sha256 cellar: :any_skip_relocation, ventura:        "9d41f336b7fe6e98419942c2b54fc7ac09fc967e93c614967b21a8693a8f1cc2"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3fc59d4ad592d81f08bf67512c044e18cb8aab47462b0e21589840018f7690"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0af700a8fd808b19072cb4a7ad2f6d84f516c7c014821b5955b525ba34248cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54b96c22880ef77f8d1b9bda14f3b62e5729b5a6cebe8255d685ef3437b8c48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
