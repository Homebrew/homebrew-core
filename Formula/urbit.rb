class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.3",
      :revision => "ab92c583a83901800344cdd52774a1b1d8d23841"

  bottle do
    sha256 "da35f7b7f69ef724abf6f7e4431168e3379b27371ed56cb2abaedf8b053db348" => :mojave
    sha256 "ef8ad3372a93fc911ba1877a939ef3ef98a985c8a382bdf21d4dd09bb070d9aa" => :high_sierra
    sha256 "40253792b8d70a87d93202da89d9c827e48e69cb6ea57c0f089f91d733dc4372" => :sierra
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
