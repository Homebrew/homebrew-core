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
    rebuild 1
    sha256                               arm64_ventura:  "c87410b78c23e22e1e5af95f6daa63e8873f84e620503897b98350aa91b05b9a"
    sha256                               arm64_monterey: "fb99f591b790de0b20615aec5da0fae2e44c448b34aa97a98aa294a730146d48"
    sha256                               arm64_big_sur:  "c7ff16ba6de865321cb09c07b558813c40931085c82a218e24b0e43c866e0aaf"
    sha256                               ventura:        "400d40793a1f87b91a9fe71de8b7daed4ca8a7973152f59c744d4b52b4fef374"
    sha256                               monterey:       "f3451322dab44f011821248060aefd9a955aecbbc32300598d5c9a36bca3f860"
    sha256                               big_sur:        "9173eef3a1adf288f93d79a92b1c9872d522e58378a3cf70029ed913bfe01ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd650317ea2402ecb03924d58635b338f03f3af5ea3b36954ecbfe48d30b5ef0"
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
    assert_equal <<~EOS, pipe_output("col -bx", shell_output("groff -t -man -Tascii -P -c test.7"))
      SIMPLE(7)                                                            SIMPLE(7)

      NAME
             simple - a simple ronn example

             This document is created by ronn.

                                       January 1970                        SIMPLE(7)
    EOS
  end
end
