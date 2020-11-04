class RmImproved < Formula
  desc "Command-line deletion tool focused on safety, ergonomics, and performance"
  homepage "https://github.com/nivekuil/rip"
  url "https://github.com/nivekuil/rip/archive/0.13.1.tar.gz"
  sha256 "73acdc72386242dced117afae43429b6870aa176e8cc81e11350e0aaa95e6421"
  license "GPL-3.0-or-later"
  head "https://github.com/nivekuil/rip.git"

  livecheck do
    url "https://github.com/nivekuil/rip/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test_file"
    system "#{bin}/rip", "--graveyard", ".graveyard", "test_file"
    assert_predicate testpath/".graveyard", :exist?
  end
end
