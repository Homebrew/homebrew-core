class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/refs/tags/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "d0a7ef5679c656bfa534874696403b31250acb374aafe0c6f6c7a4f18d6e6904"
    sha256                               arm64_sequoia: "ae47bcebfb7b492d6a6aa8f9dedcb248c79f657f37dd851b8148299120750253"
    sha256                               arm64_sonoma:  "2aa277c67249e543b65df95bd8ae64e88276b8be25497c27edf923aa20933049"
    sha256                               arm64_ventura: "4a5a015611099aa8618e53d517cbb481528383ca8a7bcaa9a9684d403378308a"
    sha256                               sonoma:        "2bdef28fa1cc074a01fe71f08be92eb459e5c6ff481af10cba987a69857cf89c"
    sha256                               ventura:       "ae254f18931f756ddbbdbff72edeafe83c69be33b59b8dd809e8ccd5dabf4a96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1d853f9d17df76b12ef43bc6e54afb4804170372ee3ca5375b1070757e6a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7039deef414574510a014b1ee4f0b676b0535b1af20fad6c46af736425608795"
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
    (testpath/"test.ronn").write <<~MARKDOWN
      simple(7) -- a simple ronn example
      ==================================

      This document is created by ronn.
    MARKDOWN
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
