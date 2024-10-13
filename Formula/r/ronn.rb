class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/refs/tags/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "bdc72063db5be27dc1d34d941c0e249b39a9c7df448ef3914863948dad7ddc29"
    sha256                               arm64_sonoma:   "416aeca29910f0ce1822a255a7d73809d4dd1a29e5d6fb8375aaf5001343a293"
    sha256                               arm64_ventura:  "408a7986228c62661d63bd01bc2d3ba03e22641018915a3366bcb4b9aa1bf92a"
    sha256                               arm64_monterey: "5cf031f43f4b10d293293263784cebbfe3d1616412dce8ed94c78ea34297cfcf"
    sha256                               sonoma:         "1660a20ae4acba5d8c2672028c1013babb989458720dbc4dc6dba2386380c5f6"
    sha256                               ventura:        "6bb2e2ffd5ab8a76357720b88ea0283b645b0f45b3dc7b30fcb38cc44612889c"
    sha256                               monterey:       "7b3601e05dd8b64eaea9783767ecf9b40dd8d70b43a497f2b8b3f8952525ca3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a73748f925012eb92e989e625d1086f08c56f211e92a5b1318837004236d1c8"
  end

  depends_on "groff" => :test

  uses_from_macos "ruby"

  on_linux do
    depends_on "util-linux" => :test # for `col`
  end

  conflicts_with "ronn-ng", because: "both install `ronn` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn.gemspec"
    system "gem", "install", "ronn-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/ronn.1"
    man7.install "man/ronn-format.7"
  end

  test do
    (testpath/"test.ronn").write <<~EOS
      simple(7) -- a simple ronn example
      ==================================

      This document is created by ronn.
    EOS
    system bin/"ronn", "--date", "1970-01-01", "test.ronn"
    assert_equal <<~EOS, pipe_output("col -bx", shell_output("groff -t -man -Tascii -P -c test.7"))
      SIMPLE(7)                                                            SIMPLE(7)

      NAME
             simple - a simple ronn example

             This document is created by ronn.

                                       January 1970                        SIMPLE(7)
    EOS
  end
end
