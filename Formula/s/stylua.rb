class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "882eadb417294399a89ba2b3f17edc751d4b6d1892e4814bfbf5c024bb89de6c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e97755a51aee4f11ee3a6b5d30a520f67ec8dc7f4f9b6f1c69eb0bd87654e5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2a3155c54508b19942dd5269df0bc41e25aebce127205f7fc29e0b27679050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88b4738a8e38e690efbf9292d159f3ff88880e249d2d0e8d9f1ef80433faba2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "37779f96c9b73660283f7a4ac844971f6af0d14b25cf3b51899562537bc2de47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75231e015de7781cdf1674e3bb5091b8fdd24edfc6ef9763a2ba0649f6bfc743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b95a841af6d3bb18dde300398ff009357860c913e84dd2db13b0783d7ef15084"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end
