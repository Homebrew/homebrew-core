class Xh < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.7.0.tar.gz"
  sha256 "428edefbb58ffdb10a731ef0f1bb15d77bb90434f3ea72b41f8e4870ac74ec49"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
