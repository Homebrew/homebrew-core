class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://refactoringtools.github.io/docs/wrangler/"
  license all_of: ["BSD-3-Clause", "ErlPL-1.1", "GPL-2.0-or-later", "GPL-3.0-or-later"]
  revision 5
  head "https://github.com/RefactoringTools/wrangler.git", branch: "master"

  stable do
    url "https://github.com/RefactoringTools/wrangler/archive/refs/tags/wrangler1.2.tar.gz"
    sha256 "a6a87ad0513b95bf208c660d112b77ae1951266b7b4b60d8a2a6da7159310b87"

    # upstream commit "Fix -spec's to compile in Erlang/OTP 19"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d81b888fd200dda17d341ec457d6786ef912b25d.patch?full_index=1"
      sha256 "b7911206315c32ee08fc89776015cf5b26c97b6cb4f6eff0b73dcf2d583cfe31"
    end

    # upstream commit "fixes to make wrangler compile with R21"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/1149d6150eb92dcfefb91445179e7566952e184f.patch?full_index=1"
      sha256 "e84cba2ead98f47a16d9bb50182bbf3edf3ea27afefa36b78adc5afdf4aeabd5"
    end

    # upstream commit "Update to work with newest OTP"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d3d84879b4269759b26d009013edc5bcff49a1af.patch?full_index=1"
      sha256 "cc37f3042433d2c862f4cd4caa0d5a6b0716bdcb8f4840098ba1b46bca52f24b"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4765b14d43dcbbd7362daed20ef277ee4f07e2d7a1c44abe9c3a87ba9eb61440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "104fedfdf25f93ef4f3c304d79c9b98f99f0e40b5dee425374b98cf70d355995"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bd08eb2e81427427c19961ea491968529f2a9a083329effc81763d75cb53978"
    sha256 cellar: :any_skip_relocation, sonoma:        "123c4474665a332b371cf4e1b0277ab632424d7d2a3ca5a78dc23a27aa2387c9"
    sha256 cellar: :any_skip_relocation, ventura:       "23bcf0e9f30302473b550eb90ab8ac96d4b1f5afd51a1da33ccd0902cca4e044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272b96bf2e4ef8cfb303bc93246b839f18557c3633584c509353f952ae4de13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309087fe8204a4c9ba1a954a159e81c5a89f6538f228068b27c36b8de4f1f97f"
  end

  disable! date: "2025-07-01", because: :unmaintained

  depends_on "erlang@24"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # suffix_tree.o:(.bss+0x10): multiple definition of `ST_ERROR'; main.o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    suffixtree = Dir.glob("#{lib}/erlang/*/*/*/suffixtree").shift
    assert_predicate Pathname.new(suffixtree), :executable?, "suffixtree must be executable"
  end
end
