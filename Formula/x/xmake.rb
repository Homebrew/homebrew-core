class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.5/xmake-v2.9.5.tar.gz"
  sha256 "03feb5787e22fab8dd40419ec3d84abd35abcd9f8a1b24c488c7eb571d6724c8"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b46ab4ad77401c46b431c035e59ab7d510d0772ace095c2e5d6e5aeb19cb4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c0e24565eda069161eb3182b445d010471677a2162b7746ab5e2c7d797bddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "789d1c9d2ad958371ce0d9c4139809e0a07532afddb68a406af61918503d2b7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa5940c4367098bca448f82a88d8c97cead3f62d5e7de4aba3026903827557c0"
    sha256 cellar: :any_skip_relocation, ventura:       "f1948254ee755587b27e6b9388e929fbcbe4f324c10bc1de081ca31c9c42cb96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c432359594e0451d9b4632f394cdb6520da2ae9a5917cf50718ab040ebba33"
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
