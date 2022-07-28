class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "606c37b84110739c375339aefeedc74a9906e59c4f559e112fc0948c13728a7b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bada0c3d962a79a8aa3abb4a9b087cba922a383f805ec5f7e391c1d7cfc3cf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b881a0e86a1444b2f4089123c96948272093712589d28f55b6648e7fbd735ab"
    sha256 cellar: :any_skip_relocation, monterey:       "7666f5558939ab67e220cb0f7947c7e6ce0a252ad3d34acc0573f3ca17763e50"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ddc634c39c460dcfb15ac93e7b708951e7878281ddedbade421acd33e72377a"
    sha256 cellar: :any_skip_relocation, catalina:       "d3ec7cf7a16dedb2064c54820de73759dadc407217a1548b3a26070ccf89e17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240937f0617bce44c4614011a8064575a551b44f130fc2d7bd9d12cde7edc8c9"
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
