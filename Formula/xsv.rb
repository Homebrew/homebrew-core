class Xsv < Formula
  desc "Fast CSV toolkit written in Rust"
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/0.13.0.tar.gz"
  sha256 "2b75309b764c9f2f3fdc1dd31eeea5a74498f7da21ae757b3ffd6fd537ec5345"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/BurntSushi/xsv.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3782f25035444ff4b65770eddc8598a1908e1538d1d338954fc22a928846db4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "410eeb772d867d03a7e80276ceb83d4eb7a7784b28d0087ed8ad49d69e8fbeb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6084d9e55244c876bbe7b833f5c7e27a19f09993f8b48f30076bd3c689f56b46"
    sha256 cellar: :any_skip_relocation, ventura:        "5c38a15fdf937d239bba53b098ea98d71fc05652123c09a56f3dfb17babb7298"
    sha256 cellar: :any_skip_relocation, monterey:       "69ffb9f95356c1bc35999511f5ee4f2d31b9ec08f3dcd3b831476f75396d63a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0b4b23b91d31f0375fc425352a11ef551a1f2c75664d3b266c7cd9d8fc57f10"
    sha256 cellar: :any_skip_relocation, catalina:       "03926e8c78a90a6ad209dbd61d312e6d70d929e84a9f3fd325aa8fa81b8ccec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e6982514f6800be13fbbe4d1e2512023baa2f3bb2dc9e4bad87c0699bb911f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xsv", "stats", "test.csv"
  end
end
