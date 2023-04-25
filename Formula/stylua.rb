class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "94d421033a41d7030bfec5cafafd16e52951b08685f4a908087cbcbb8fea4073"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108711d1342dc6083dfa9ec4a89ddaa9f6cae2f911a4d21ace3c49aaaa7a30bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf51c88038c200be3439cf42397d746d2dd4c93c7ac742ec2e67fcc84105fe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79da186cd45ecb375c8707f4da4816ec6acbe826fd6fae34325035cc783afaac"
    sha256 cellar: :any_skip_relocation, ventura:        "f9aa218a05c92c056a23bacd2ebc27180174d43136c4a4d1f7f5458eb7ce5636"
    sha256 cellar: :any_skip_relocation, monterey:       "0edcaa40b09ea7cf75fe43b9e32144091789d3723bc4ee2adf9634c8b027a989"
    sha256 cellar: :any_skip_relocation, big_sur:        "782d7efa40fbbc640ec361c6e538d937805a65ec9382450c1fc9ada872ff48d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4955a20d73dd0316f734ba6362495d968a51de022c179b565a2f14748ca360"
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
