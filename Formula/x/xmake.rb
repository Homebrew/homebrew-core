class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.9/xmake-v2.8.9.tar.gz"
  sha256 "5f793c393346ef80e47f083ade4d3c2fdfc448658a7917fda35ccd7bd2b911b8"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df7761cda3ce981d89f59d371d30e474517d892b736ab189c7158faf4204d49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1e4ccef72531124b2d0912ad02847cd4791c3abb88957fc5c127615283c1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e11ef56a27cc561e6b2d4b5af04ef91b1a377a85474bfdf4b906f2fedc754b53"
    sha256 cellar: :any_skip_relocation, sonoma:         "90cbc0d9551e29a71b8bc0a3cc4e6e2d15399534f9df2494ffe6895a25880088"
    sha256 cellar: :any_skip_relocation, ventura:        "d31325567c7fad9e06e9b73d29a6ed08a0bda5b03c94dd31cda01e80fc03f356"
    sha256 cellar: :any_skip_relocation, monterey:       "0b518a4e476185a46ed3f3f1be28e5188ac1813fb0be8373768f22ea0e7a7b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2711c9199eb717cc6501db1ce22fb59350dd3bef69c86a77d92f1a2ffece2e"
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
