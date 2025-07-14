class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  stable do
    url "https://github.com/koalaman/shellcheck/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "149ef8f90c0ccb8a5a9e64d2b8cdd079ac29f7d2f5a263ba64087093e9135050"

    # Backport upper bound increase for filepath, needed for GHC 9.12
    patch do
      url "https://github.com/koalaman/shellcheck/commit/0ee46a0f33ebafde128e2c93dd45f2757de4d4ec.patch?full_index=1"
      sha256 "c73663bee3577068700b580140d468834cd42f88f7753f950f501e8781656ff5"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5045be1e530288251353848343322f5a423617d061830b7ea7465fe550787364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef742b6992cfcdcd7289718ac64b27174e421d29ce3ad9b81e1856349059b117"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e60ee03edb09ac5bc852b8eb813849fa654400e21ffb4c746989678172f5a26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e8407806dbf757e71930ce2cb9b0d23bae286f0c058d9ff246d851dd7aa871"
    sha256 cellar: :any_skip_relocation, sonoma:         "b53cf1e5464406ee49743fc2db84850b6d34d3a2098cf729e629b23f9d6dd6e0"
    sha256 cellar: :any_skip_relocation, ventura:        "15ba88c48a5ae3b08e085791e3c5e514d9d78ce88414c96bd21ed33f29fb4aca"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d14cb62e325d0f7221cd24a7fb4533936feae4ed4dce00e8983ec6e55123f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2e5ceec4e238594c795e31266086f0dd6d511d858ca21a4f9783f0e6b3dd7e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0867f144686a5caa025cb15ecac49286654b78e7b89979a54eedc9a0cc9b6b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    system "./manpage"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~SH
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    SH
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
