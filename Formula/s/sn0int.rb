class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "4ce71f69410a9c9470edf922c3c09b6a53bfbf41d154aa124859bbce8014cf13"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c653c908a5dcdd3cae0ccae42321a281e01f2530a35e4153997a2fe161d1b8d"
    sha256 cellar: :any,                 arm64_ventura:  "42a404e0734f6c386b56b078919b20225d9fef3abf867801303babfa4ee734e7"
    sha256 cellar: :any,                 arm64_monterey: "acdf793db2ffef84e021185aa89a1e388ddbd78f67e6e09398142dc4d9923ad2"
    sha256 cellar: :any,                 ventura:        "95ffc0357363e5d4d526c35466e132857d9aeb93bfd0f201e7e309443912f8cb"
    sha256 cellar: :any,                 monterey:       "32f7111dde2b5fdaed7236698c515d7cf59484d780e88b0decd24d1bfbaaeb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7407c25ca45288c49d33c2c091c09ec20223b561e92994bb5e6f02b94307be16"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sn0int", "completions")

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system bin/"sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end
