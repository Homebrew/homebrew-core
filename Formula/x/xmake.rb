class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.5/xmake-v3.0.5.tar.gz"
  sha256 "b947666281222f79e082283b6f84e68880c499305890f6ab8b03b8bac82456dc"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e122e50452d8057044ca9bf2664e2913cc06b468fffea12851ed2b2a83197b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b1c4afeac76a18f56aa1d90a08a64691aed264afa1e6d5e8ec1b18f04b93455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c910ea78c06b36c60cd1f6cb3e844ee395fb77c65d332061bcd293ef82555ac7"
    sha256 cellar: :any_skip_relocation, sonoma:        "289dcf003043dc5b67086f8fc825231e3ade7b215ea2d864e006bd242fc4f8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c05e7972405094cce476618600c1aa8f17f9bac1df38459844bbbe0c2ed6c767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb08339768e2a3c44000f89265364b9bdd8c9810f9ef340aade906ad7daf5a9a"
  end

  uses_from_macos "ncurses"

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
