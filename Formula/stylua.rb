class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "21158028569158ec7c1ad71352f3cb1906a005eb797508aa2b0b4a861162cf72"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "475139fb165fe25f54b107369e44b83d473ebe89ed97cb2d773b94d04424eab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71bdf484fff3fa98fd3b0dddb0fa6b11b856d15e09f99698420b8a96032dab99"
    sha256 cellar: :any_skip_relocation, monterey:       "17b5665f5be9deb5d31f01485a04680729761372eab0ca728ed0dfc17641da5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d375ad07b594fe95ea9df1364b56f5108e46830aecb7c36bfc6e208fd6c500cb"
    sha256 cellar: :any_skip_relocation, catalina:       "4011aee383785fc6302605fd659af37def2c326bce6645c1996a582bf22e4ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6254f56b0076ff5fc5b3ce21f15e4041ee0d21e2aebfafd143b8ef5d5fafdd10"
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
