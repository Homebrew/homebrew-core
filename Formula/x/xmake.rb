class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.3/xmake-v2.8.3.tar.gz"
  sha256 "042e916b355b4f5b2be112d0d594788476465c3a854afbaaa6de6f3f2303ca50"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a28d3ce3009651693a8ba76be29b0f6b0656dd60572f71c61d677de9b521e24d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e2c68561d1787ffe2b888782f5ddb5b2629a03f2aaa9a7dbca3dd3f998aa21e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39812a06d2cf6791ea892b214c749b7d99de1f42c03b1cb2be59306648ec5f9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8824de0401bdd12dc8b1dfbb26bffd46ee11c54cc4a169c47201708caa332da"
    sha256 cellar: :any_skip_relocation, ventura:        "71504224c111ca4e5ad7da2cb56963668fb9dd346267b1b4cf9fc365da9e6ad3"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7307722accbe5f166640ffe3eaded415b05e874ba3c499dd0bc7759d79886d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b9a65a03f4f297aa02fb557ddbbd90e82dba3591db5d62ddbcc50ad2948f22"
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
