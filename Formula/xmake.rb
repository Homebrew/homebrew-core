class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.7.3/xmake-v2.7.3.tar.gz"
  sha256 "3e71437ad2a59d1fbbc9fba75ab4ca8d428c49beefcce86c11f6c4710dd4b6f2"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69c4e0fcd501004a3bb9c4c6768aaeb2900b8f9a94909bdcfaed474f11d16d16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e68ab0c7020405208a0c07b4ebb5b8dfa092bb43a00e87b095475ec0bf78c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c2e87cb7617acfa6247adce8c071e1ae248d675c60bef0e9c347687b988a239"
    sha256 cellar: :any_skip_relocation, ventura:        "f362db6902ebaa03484d4bb881855d3519767483ff5c3c01916d15e0a6f8d628"
    sha256 cellar: :any_skip_relocation, monterey:       "8f005b7219f20c128a09ccb34971969b4dee91e171b2092a5a541e7fcc70e56f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a29f5aa5ccc8915c509b0bf7e14516068da31c235567bc006563d27ddb0389a4"
    sha256 cellar: :any_skip_relocation, catalina:       "59c4d0d56d5324e688e447bf8df0f1f68c941740e7c0b7d4b1cc4bb72488f9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021e6fc970023ba98e0619477f94199b853ef2c7b38f9c19796212b1882c6203"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XMAKE_ROOT"] = "y" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "make"
    system "make", "install", "prefix=#{prefix}"
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
