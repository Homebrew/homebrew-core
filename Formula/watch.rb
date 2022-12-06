class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v4.0.2",
      revision: "135069f2b2d007353a549d7589a97aeec55ab3ed"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef337cb24a0b691a5d5d7d41bb6d3f2e1d056cb2dae41dc0d7e8511c1bb4406c"
    sha256 cellar: :any,                 arm64_monterey: "88aa76633ada5e20079fd09d4a1fa72e3a7315a93774baddca05bf1a71fab9d0"
    sha256 cellar: :any,                 arm64_big_sur:  "7d81da07b4ab53b96c95796ddb0e144cdeaa5c9bcd1b29fce482638b89c33095"
    sha256 cellar: :any,                 ventura:        "142fd3f744b55edca38323c5441d527a85f40e2044adeaf0e0bc35512bbdba1a"
    sha256 cellar: :any,                 monterey:       "d62ec054a92933495ca94e193923a4137776a28704e3426a9fae50e1b80b5046"
    sha256 cellar: :any,                 big_sur:        "86dc7c8a7d9bf3938dc25766a7b4a4cee6540d7e821f76030136b6c939577e81"
    sha256 cellar: :any,                 catalina:       "637ebed20d7e68d640df48580ed42a9e87389509c3634dc295dc4b04c5d6d575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2626dfdcc5f306d14c2342d27d59ee9c7dfa04fd0c525e064ee801bd4fe2ec97"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "src/watch"
    bin.install "src/watch"
    man1.install "man/watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
