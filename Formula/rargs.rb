class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/v0.3.0.tar.gz"
  sha256 "22d9aa4368a0f9d1fd82391439d3aabf4ddfb24ad674a680d6407c9e22969da3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "37d5a3c2a5608eb4a10df0814a1334b88602a7200fdf99db60113f7aea598489" => :catalina
    sha256 "1c24f60f8b91301cd167b0040e2c9ec7895fe818eeb21f13d40fca94e6f4f08b" => :mojave
    sha256 "9cea3ec1abc342281b94649496e0d28275eead691238a2d03e47c2621afc9801" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "abc", shell_output("echo abc,def | #{bin}/rargs -d, echo {1}").chomp
  end
end
