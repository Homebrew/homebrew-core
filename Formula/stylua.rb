class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "03999c22779f4dcf68fdf92d143a95afccd6c6554da27af308fd826179db80f9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7796d48f5b77c1dd290b08edbca2b67b9639a358ab91517038d151ffce4159d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1186ebcd3b943a9f88291525818ed51563191b7c5267a96de6acdc461648f19f"
    sha256 cellar: :any_skip_relocation, catalina:      "0477d5b24df2e95e38e411a4425ec5bc5cca022fb5776afa2a0303d06db311f1"
    sha256 cellar: :any_skip_relocation, mojave:        "cccc5e26fbb5337499443e10d68f4a3548ec40a468c4ea56779c4e40342e81ee"
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
