class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.1/xmake-v2.9.1.tar.gz"
  sha256 "a31dbef8c303aea1268068b4b1ac1aec142ac4124c7cb7d9c7eeb57c414f8d15"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "229f2d2427da6d1f15a32142e688fbcf4245a832e55aa0f170e916f67de1f020"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335b88f9704377c6f02c91cfce1dfd176f7d078329951efcd6ae7cd997204704"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902f2e741faeac92d65fe3ffc4b07d1f23274c1acef16e88d1061c1c65c7e552"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd7ff93005858301c4edda2ea2a074db3a3d0a1e7659842331f251e00b66778e"
    sha256 cellar: :any_skip_relocation, ventura:        "03e24ed969ea5fefc3537e956c7fb1df72c374cc51f962411d3252b3dbee658a"
    sha256 cellar: :any_skip_relocation, monterey:       "9456eeed677eec804370dfd26b8839be655d8298730c8c8782e1d9079e9b5c83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f8118c4a169d7f12c7c778a202cb958ab021c18137e7dc35b66d437bcba6b2"
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
