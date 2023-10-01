class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "4ce71f69410a9c9470edf922c3c09b6a53bfbf41d154aa124859bbce8014cf13"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6415a95bd619a030f851a83a60f405c23d5ea4492263b51eeb6c137e0101785a"
    sha256 cellar: :any,                 arm64_ventura:  "4d20a6e19b7aa98c411722f19bffef7ffc3e75554be86d248d7a0ff970e51eb7"
    sha256 cellar: :any,                 arm64_monterey: "a19b7a410639c804bc04d5052ae49df58d834bd4116b1268e007be6016cd6d63"
    sha256 cellar: :any,                 arm64_big_sur:  "c0c9e6010d3400a040ffeb4a512174f0565aad224f7dc9f6b0d9a96d9ca9f01a"
    sha256 cellar: :any,                 ventura:        "dd83c87da148fd5a745b1e4148f0312b8c1b243b33488c92f40bfa971fdf89c9"
    sha256 cellar: :any,                 monterey:       "67e5aead2e26fac75cb92fe0b6133c905637b6d4f855bfeb8fd556e96e77f2d6"
    sha256 cellar: :any,                 big_sur:        "c3777031f85c33a0a541d973d2c970368f785e75906eb3f2fc15c505f7b9a239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb3272429b612d549220af36d0ae97a867c69747d7c13965c0baa12514bcfd98"
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
