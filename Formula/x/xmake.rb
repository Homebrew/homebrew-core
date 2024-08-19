class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.4/xmake-v2.9.4.tar.gz"
  sha256 "75e2dde2bd2a48a332989b801ae65077c452d491fec517a9db27a81c8713cdc5"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0723c1ecf87b6b33384a8283567bb3f24c4126b62157db2c2b5e258771d5ef60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa78f17fc76dac0f340db156c98bced32ae5b177894f0052cd7cb0aa6d87d946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7ad8b83d15ef2a96a2f0284839892aac6ab289bd55903dd3aaf443266645133"
    sha256 cellar: :any_skip_relocation, sonoma:         "886f28d50d68ed6bba0ffcee2105f1899b751d250f310ee675ea9fc2e0565687"
    sha256 cellar: :any_skip_relocation, ventura:        "006f416fbba6429476708d98767e66c57d5e3bc9606849a6bddd873b15f9f209"
    sha256 cellar: :any_skip_relocation, monterey:       "a1b423e6cd500c93ede366ed49abe652d81bda357ed43c7302b9c73b790c40fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da5cf9de532311811cbc20c37626914fda85f01c29b5c9a37ad12696cbedb07a"
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
