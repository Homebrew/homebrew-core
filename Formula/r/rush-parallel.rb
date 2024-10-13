class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "57450967bd222964f4865d7884b358d391e30d6eee8951b149f34f8642a32958"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dec8fcf099e7d8f5a089ea85cc14ce075a941dda2977a2922ba93db6fa313663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc134bdeb1f45da45415da9afd754faedda3216c381a40e4ad276fdf0a4f0d5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84527df6822a3c96fbe1f3bd5f64842dacd941ad635353a8492be7544d75ce99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a7ccbfe97e582202faab7204fafef37033cd0ee5d7c9b32ee352e9435f140d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "f72c193f784b9daa4842fd6142587e35ae4d0af1910a9c024e7a03db339d837e"
    sha256 cellar: :any_skip_relocation, ventura:        "c1b6bcab40fb133dcbb72d87cb9adc6b1e1dbcfaabd1165585fef689533150c8"
    sha256 cellar: :any_skip_relocation, monterey:       "9fc430bf28d8d0575cbc824582cb143027ea0995eaeb430a64bf4e342783fd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b750c49b1316b191f32c638041be3bf67dfbbd33991ecf67a14a96cff91bd9b3"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
