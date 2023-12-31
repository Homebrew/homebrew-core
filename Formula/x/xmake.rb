class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.8.6/xmake-v2.8.6.tar.gz"
  sha256 "0e6284eafd51a3236098213c095237f56acafae9a88a50406b882cce5ea26b3d"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f769d95e9225da902f3939569577b1fb93de5cc020f1e1c95c6082d81da9d097"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb18885734486ff82a02a843babb854a53776a9e4dc3501d5d4317f346462808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f39b399ce2db47616a30a02509e2c4b2b50cfd5729c36c5187f52e94146e025"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddd68b8d67dc42e077eefc56c0bf65f8373f1726f392bab09f3075a7b0e1abe4"
    sha256 cellar: :any_skip_relocation, ventura:        "f01a4e720d1769f71c4f5586588065b46007b5c1b38faf3e9f7e3cb7bd2a8d8a"
    sha256 cellar: :any_skip_relocation, monterey:       "69ca5f788bd938994a702d8991c2d4887e658084c4e3ebd8f12cd0c18b95a32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13092d3a7ce17c24473521d18de8817dfd8eaa67f30af1541c3bf571e798eb5b"
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
