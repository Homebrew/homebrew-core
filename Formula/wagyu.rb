class Wagyu < Formula
  desc "Rust library for generating cryptocurrency wallets"
  homepage "https://github.com/ArgusHQ/wagyu"
  url "https://github.com/ArgusHQ/wagyu/archive/v0.6.1.tar.gz"
  sha256 "2458b3d49653acd5df5f3161205301646527eca9f6ee3d84c7871afa275bad9f"
  head "https://github.com/ArgusHQ/wagyu.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
  end

  test do
    system "#{bin}/wagyu", "bitcoin"
  end
end
