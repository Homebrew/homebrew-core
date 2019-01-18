class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.0",
      :revision => "a42f2cbe5ccc591c148464444264c8f6c92776e3"

  bottle do
    sha256 "07e5fe7f6ceb476f9743b31c0892d4f0058d240c560409fa2746fa1d7d9fd7ac" => :mojave
    sha256 "fa1d6c586c0caa327a7aee101093a9aa5e5e8d6e9ae16969e566395502ec2dab" => :high_sierra
    sha256 "ce3d5193c9f28b63a345e578de5cf7bbebbbf220b7fa230db390bf56ceac4b6b" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
