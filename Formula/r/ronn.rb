class Ronn < Formula
  desc "Builds manuals - the opposite of roff"
  homepage "https://rtomayko.github.io/ronn/"
  url "https://github.com/rtomayko/ronn/archive/refs/tags/0.7.3.tar.gz"
  sha256 "808aa6668f636ce03abba99c53c2005cef559a5099f6b40bf2c7aad8e273acb4"
  license "MIT"
  revision 5

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "56ccd5c1249492486887b691294cc5e521a62e9231ed4f0db5a1306db44ec24d"
    sha256                               arm64_sequoia: "2054164b76be1b88a653e4b65b073a7130ca248555730d5c69e38e0889f7c6a4"
    sha256                               arm64_sonoma:  "c91aa9b37dd6e5d962e37c66fe2e9b04e44204d2a09bf464cd4c2bf247c305ff"
    sha256                               sonoma:        "a7545d2ab894ffc07599930c70aeebec826619b150d37f91a6e1f7dec4f4772a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c9d3d1240e95a231b3136f13d93a5c628599ef75e4560363970e0cdf8223b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a40cabe57b7456d236125ccb6ecd55d0a9a89bf0eb34bf5ad4933aaa9c6cbd"
  end

  depends_on "groff" => :test

  uses_from_macos "ruby"

  on_linux do
    depends_on "util-linux" => :test # for `col`
  end

  conflicts_with "ronn-ng", because: "both install `ronn` binaries"

  # Fixes "undefined method 'has_rdoc=' for an instance of Gem::Specification"
  # Gemspec was last updated in 2010 and uses deprecated syntax
  patch :DATA

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
__END__
diff --git a/ronn.gemspec b/ronn.gemspec
index 973a9b6..5708a9a 100644
--- a/ronn.gemspec
+++ b/ronn.gemspec
@@ -89,7 +89,6 @@ Gem::Specification.new do |s|
   s.add_dependency 'rdiscount',   '>= 1.5.8'
   s.add_dependency 'mustache',    '>= 0.7.0'

-  s.has_rdoc = true
   s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ronn"]
   s.require_paths = %w[lib]
   s.rubygems_version = '1.1.1'
