class Regldg < Formula
  desc "Regular expression grammar language dictionary generator"
  homepage "https://regldg.com/"
  url "https://regldg.com/regldg-1.0.0.tar.gz"
  sha256 "cd550592cc7a2f29f5882dcd9cf892875dd4e84840d8fe87133df9814c8003f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c69006dc5eb93be0eb6b39cb396e59e8c09aa5d65f56a216cd19753a7f28232" => :catalina
    sha256 "15f7e95f3d84d091a942e836ab9a27b3df2594e3f378da26f10371e7ba01be5c" => :mojave
    sha256 "45950c0b432b227711570e3b9ea79fe9bf96b3239a062c5a736f9a3fdf294fb5" => :high_sierra
    sha256 "26f12ca7e41b36a167d94f403b97557490fd1ad0ed1a2d4d0b30c86164ae9d39" => :sierra
    sha256 "52c64d6766b68a1ed602d3878368109d3ac3e5e60d6fc14a4606518d14f6e678" => :el_capitan
    sha256 "c4157a77e2620b868b2dbbb3ebf126193b238c6a69d2a895420950d4203d7a17" => :yosemite
    sha256 "4b3d32f6aef97ad10f581d455f4e2d97babb42e5abe749a2f746a91f10051cc6" => :mavericks
  end

  def install
    system "make"
    bin.install "regldg"
  end

  test do
    system "#{bin}/regldg", "test"
  end
end
