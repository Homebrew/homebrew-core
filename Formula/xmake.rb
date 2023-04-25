class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.8/xmake-v2.7.8.tar.gz"
  sha256 "d4112587fb0e74037ff1ac32d2f1000591ac1a297fbd74645f9b031cb079585e"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31870026eb5ee44ebe2f8eb906dede2d09417cc4c9cc24dae036ad767f7e2b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e8b4a2ac8cb357348b5d4ff237e2083bf3a0f6a5ec11df8798f771e8711eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc03592b0828e60790787240950969d9a7af2438cc682ed010e448b69cfb030f"
    sha256 cellar: :any_skip_relocation, ventura:        "ab530a91b0a303f5b45b4533ede19520abf28935d0ffbf3a9ea0618515177e67"
    sha256 cellar: :any_skip_relocation, monterey:       "ff5b9de0e725c72d3264d394e3008c9565b9674d16aa526bb0b61c9a404e8de1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab7d4686d0ace0f599f07d2ec004608d75daf153206c72cb34997e31dfa4567a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed5945e56c6356310c57d4ef19baffe4ab2ee5f862ab3f0563dd96391b1d7d97"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && (ENV["HOMEBREW_GITHUB_ACTIONS"])
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
