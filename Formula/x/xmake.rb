class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.9/xmake-v2.8.9.tar.gz"
  sha256 "5f793c393346ef80e47f083ade4d3c2fdfc448658a7917fda35ccd7bd2b911b8"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c1c26a8062a00dd66427f8e259797fb73a425e2ac55cb2b20018bad3c1776d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4fd73ec60196f4d56eb4aecbc7a8dc01ab3327a025babb9cf429bb50423f7ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe0ff4f9be1131eed681b0b12d8274e8673e626928321f223c719695bcb8860"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea8493a5f3a38dcf2aaac0e659d8830ab9cb38567825d750b61cc4ab248897f2"
    sha256 cellar: :any_skip_relocation, ventura:        "5de799973141d4a23ec8435f24cf4e0a0b51e75909c0b0544f52f8f601a19185"
    sha256 cellar: :any_skip_relocation, monterey:       "4ffdcc7157b884a0a406b2f7a5fd269a4524859c065d153a460a254f300b5cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ed0c91c3fb6de750bf7a13d912fa6154cf9b30f431a2894ca5fc766730a0858"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
