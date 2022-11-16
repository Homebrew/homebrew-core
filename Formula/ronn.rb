class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "619e4bc705a2b76f1a172f26addd7b602e46a1629701b03bfeab699c2a7ef9a8"
    sha256                               arm64_monterey: "2f89aae0f91bdd8f9fd78735e9df17d431cb51b909f8fdb898a0390f2050debd"
    sha256                               arm64_big_sur:  "e2571e7b4050d3155b0b433d910febd2809082db77240bd2f1adb28f353a6a50"
    sha256                               ventura:        "f8dd86ef5e1db413727574197e30540537f28d0c41db6343d48cb1bfe5cfe49d"
    sha256                               monterey:       "dd392f329175492f8be04af6e806184bf88a78e2c01abd3ee8a8e0064d3bf2c2"
    sha256                               big_sur:        "f454a854b1633f682a373bdaf766208f05b6be7a5066ff3fe2d37e1b96615acf"
    sha256                               catalina:       "0a41650e18cc230f86ce33858afdd936e3b3bd95234d8e58fd5377e4eab69379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010026d4a9920e007b8660518a95d0b8b0b50d31f413aa4aea6ccdea165e4218"
  end

  depends_on "groff" => :test

  uses_from_macos "ruby"

  on_linux do
    depends_on "util-linux" => :test # for `col`
  end

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
    assert_equal <<~EOS, pipe_output("col -bx", shell_output("groff -t -man -Tascii test.7"))
      SIMPLE(7)                                                            SIMPLE(7)



      1mNAME0m
             1msimple 22m- a simple ronn example

             This document is created by ronn.



                                       January 1970                        SIMPLE(7)
    EOS
  end
end
