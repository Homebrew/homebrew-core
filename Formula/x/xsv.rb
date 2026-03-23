class Xsv < Formula
  desc "Fast CSV toolkit written in Rust"
  homepage "https://github.com/BurntSushi/xsv"
  url "https://github.com/BurntSushi/xsv/archive/refs/tags/0.13.0.tar.gz"
  sha256 "2b75309b764c9f2f3fdc1dd31eeea5a74498f7da21ae757b3ffd6fd537ec5345"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/BurntSushi/xsv.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a372cb2219b14b253d163e31b9a173a11242c11af0168e696a69ae78c5cdfd19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f8ba12f789a98e3a3e81ef93360446b18b6b228bfce275b622cf8568a7e8cf63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1851aa7da108f20034e0507616b2f2259d0211c522f0d0446b596181d10dae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3782f25035444ff4b65770eddc8598a1908e1538d1d338954fc22a928846db4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "410eeb772d867d03a7e80276ceb83d4eb7a7784b28d0087ed8ad49d69e8fbeb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6084d9e55244c876bbe7b833f5c7e27a19f09993f8b48f30076bd3c689f56b46"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ba92e0a053afcf8f5468e34c67c9a366eeaadd42b6387a6ab19e656774afc8c"
    sha256 cellar: :any_skip_relocation, ventura:        "5c38a15fdf937d239bba53b098ea98d71fc05652123c09a56f3dfb17babb7298"
    sha256 cellar: :any_skip_relocation, monterey:       "69ffb9f95356c1bc35999511f5ee4f2d31b9ec08f3dcd3b831476f75396d63a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0b4b23b91d31f0375fc425352a11ef551a1f2c75664d3b266c7cd9d8fc57f10"
    sha256 cellar: :any_skip_relocation, catalina:       "03926e8c78a90a6ad209dbd61d312e6d70d929e84a9f3fd325aa8fa81b8ccec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "02e2a58f3b402c91ecd421ec35060208a3a8b35d45349ac0537fc6b770f2da59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e6982514f6800be13fbbe4d1e2512023baa2f3bb2dc9e4bad87c0699bb911f"
  end

  deprecate! date: "2025-04-27", because: :repo_archived

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xsv", "stats", "test.csv"
  end
end
