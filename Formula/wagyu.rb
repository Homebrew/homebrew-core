class Wagyu < Formula
  desc "Rust library for generating cryptocurrency wallets"
  homepage "https://github.com/ArgusHQ/wagyu"
  url "https://github.com/ArgusHQ/wagyu/archive/v0.6.1.tar.gz"
  sha256 "2458b3d49653acd5df5f3161205301646527eca9f6ee3d84c7871afa275bad9f"
  head "https://github.com/ArgusHQ/wagyu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3a5aa09189771137686bdf191e8c4d92605046e72f85921cfb9ae25ded7f0d0" => :catalina
    sha256 "63ce808a32a7cf7f73e4fc37d3665c06ddcfa920720d0a0175528e93b86d9992" => :mojave
    sha256 "82c1f93d5905a7614d75f45314f584aebe7181050bb3476483a6c954e0ba3997" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
  end

  test do
    system "#{bin}/wagyu", "bitcoin"
  end
end
