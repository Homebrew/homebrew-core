class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.1/xmake-v2.3.1.tar.gz"
  sha256 "4b1b46233d84259a66bc112d05513feae2507f1b30b4c2a494c4bdf84e5845dd"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6aa389fe8fcb4df79ea59f531f3c9548559ffb3345ba55e97acd886ac8e4fb1a" => :catalina
    sha256 "b67ccf857b042dad2f8f7c8de37fa16bec192dfb5b85656875406c3654558e40" => :mojave
    sha256 "78c6d0dbd13b614c4831bbc62a7a70458367b2994b0e7fa08770448a92786d0c" => :high_sierra
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
