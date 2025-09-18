class Rmlint < Formula
  desc "Extremely fast tool to remove dupes and other lint from your filesystem"
  homepage "https://rmlint.readthedocs.io/en/master/"
  url "https://github.com/sahib/rmlint/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "8ffdbd5d09d15c8717ae55497e90d6fa46f085b45ac1056f2727076da180c33e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d90cd13c8a94f6fc34bbdbf82ae92ce390a501cb7719eed1c3e5ba7e5a17311"
    sha256 cellar: :any,                 arm64_sequoia: "271ea48a158868357536e3dfff58e0707e33f2ce3a14a8040b25ac08b6434474"
    sha256 cellar: :any,                 arm64_sonoma:  "b2d780f8713b5f8e9979f38f4fa9cfa831cbd65b2e1a206d8e760606335b2e78"
    sha256 cellar: :any,                 arm64_ventura: "ade2340e57e28b4693f73a4eb919f17bf1a18d39ab268f0ae51d984bf0cfeced"
    sha256 cellar: :any,                 sonoma:        "bfc2a7bbbd018d9fa63b6dc5fcdc312e6811bd713a465da66b9a81f1ae03f72e"
    sha256 cellar: :any,                 ventura:       "c6a8d12e5c6c75922cb42ebcacfc59b9d659328cd05b566a9ea3b262aed5b79b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7bbe7f7dd26aa3ca9a053570ab919cf162b723ae2f92fd1e90e98e22a54afdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9369f955ae09325e3c66a511024ea6dd65cb6c5bcca1cba03b7ad3fecc8cfb"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "scons" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "json-glib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "util-linux"
  end

  def install
    if OS.linux?
      ENV.append_to_cflags "-I#{Formula["util-linux"].opt_include}"
      ENV.append_to_cflags "-I#{Formula["elfutils"].opt_include}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["elfutils"].opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["glib"].opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["json-glib"].opt_lib}"
      ENV.append "LDFLAGS", "-Wl,-rpath=#{Formula["util-linux"].opt_lib}"
    end

    system "scons", "config"
    system "scons"
    bin.install "rmlint"
    man1.install "docs/_build/man/rmlint.1"
  end

  test do
    (testpath/"1.txt").write("1")
    (testpath/"2.txt").write("1")
    assert_match "# Duplicate(s):", shell_output(bin/"rmlint")
  end
end
