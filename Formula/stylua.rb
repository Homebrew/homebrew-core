class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "ce6b4a6767b17f8d609e8c9d666c5f6f5c2863edd0638e70392bfe55f99b4fd0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ca63ffb602a604f6fddb76406e39d62ffa1dd9921901144ae02a05a5108431a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "961152e853b0866f464b7a9589e81735fabcada547f5d4f44da32531d876a73a"
    sha256 cellar: :any_skip_relocation, monterey:       "8e10efc95f4bffad2796fbfc51d4ad5d89d9b4a3cfc6b37f7b1c6ef15f7ed373"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84ead5137052bd41891df5b127d0573bec4a7ac978faeec9b70dcda233ab25b"
    sha256 cellar: :any_skip_relocation, catalina:       "70b4b8303d6ed639d7122ebe97bb3133ad79572f3b662f36e1e1d5c8b5580c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65b2ba6e71e1818fdd32d482f686ea55ee8503b25a3f42baa48e8047334e088a"
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
