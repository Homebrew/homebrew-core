class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/v1.30.2.tar.gz"
  sha256 "e26d9bbea734245bf63171224b30661c864bafc699cf93ffb268bac25cd74ab5"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"uplink", "./cmd/uplink"
  end

  test do
    assert_match "invalid access grant format", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
