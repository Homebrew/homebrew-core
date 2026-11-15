class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "d58083b5d453df38b5c78c6839e80b256b434eb7d4aca3f529a1972b6c9115ac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5fbe001873e01457ddc69ce80e5c188565b184355d0e0e043cb4d50adec94e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8cbae790ee00a1e767e1d04445b5442e23eb28eae7ae02d1f88d188b6e022e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5d28a6120e8c3dea5cce270f34b3d776ba00a11aaf4f3b9521d65076e425dfe"
    sha256 cellar: :any,                 arm64_linux:       "a7f0046f3a8d593700bfdc71ec151721a2f10f4ddb03938db2af4ab54ed8e573"
    sha256 cellar: :any,                 x86_64_linux:      "36958ab1c0f811074a70ee049d4a8b0462618cc4bc47b32e1a8117220b19494e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end
