class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  # pull from git tag to get submodules
  url "https://github.com/urbit/urbit.git",
      :tag      => "v0.7.4",
      :revision => "e8416596fb7c47e343b49ea5ec12c2a095873c2f"

  bottle do
    sha256 "1cbb718456918a091972483794905eb36e6454ec695738420e1aea65ed294da9" => :mojave
    sha256 "c40b7ee58aca46f70991a0dff2e3713896c5a618ff91f005915151fd43ad80fc" => :high_sierra
    sha256 "8a8ca40b3158ab02edbbea34893a3e482ad8e2435b2ba20a92ea346ff70a0640" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    system "./scripts/build"
    bin.install "build/urbit"
  end

  test do
    assert_match "Development Usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
