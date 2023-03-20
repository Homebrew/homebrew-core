class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "c5e7a90b72cbaa1a35c4ac4d936d158fb9ae260f596c61d8970dbbca50ab333a"
    sha256                               arm64_monterey: "7e76db3363362b07768e2bad9a4759593891d9404177e8aa816c96f5f82d543b"
    sha256                               arm64_big_sur:  "7c31834c062487315b2943bd04e652757d2bcd38b6a4ee8139f8e1b44108fff8"
    sha256                               ventura:        "bdc695822c2a7d61cc9ca71a53ff964c0719b8c2308663f065f0936334c63bdf"
    sha256                               monterey:       "481aaabfe48cf8d4cd35b3ba5b140db8790b5f79aad20baa553591bed87bf4d4"
    sha256                               big_sur:        "d1bdf3a0223e34208d762933397bf3d15ea0c7ba413519ba96f5e02519e96dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aad5803b03234fa52d4308c71ac58bc45b3c792630d1a4e165848e2ae0e61ef"
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
