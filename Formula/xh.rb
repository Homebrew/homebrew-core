class Xh < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.7.0.tar.gz"
  sha256 "428edefbb58ffdb10a731ef0f1bb15d77bb90434f3ea72b41f8e4870ac74ec49"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba56c393af8c7c69f36da15e7b31fd3dc74352633660b2b245b477a7e6cbfbee"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d8dea8525852e9fc1215e150e4d4bc273905036b3835483a51a860881afeee8"
    sha256 cellar: :any_skip_relocation, catalina:      "8530dbb7d683d9c96ea7a463b0327955d3da49264a4fea07371b8d39b6288e3d"
    sha256 cellar: :any_skip_relocation, mojave:        "fe97a5675e84bf52d192fc964917a34ca02e98afe3d762e76ade103d62a0ea23"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
