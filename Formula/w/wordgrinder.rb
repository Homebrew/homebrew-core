class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/refs/tags/0.8.tar.gz"
  sha256 "856cbed2b4ccd5127f61c4997a30e642d414247970f69932f25b4b5a81b18d3f"
  license "MIT"
  revision 1
  head "https://github.com/davidgiven/wordgrinder.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3246a1cccfec9059f9801b89d70312543e99eb7d9c7804af04f6bf4b97221eff"
    sha256 cellar: :any,                 arm64_sequoia: "8e499389ffc85f7b3d5ebe39ae10b8a428b2543fbf436e6ead264c23a7f5301d"
    sha256 cellar: :any,                 arm64_sonoma:  "059c99807a2495f2b97d1af8f60aa0f131f3060d5728f5fae70e91459c05886f"
    sha256 cellar: :any,                 sonoma:        "851c8e31fdb6606c135df322bf0e9672dda0b85656130e7ebbc119dc41b4fa47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7868fa15eaf6fdedda40d72a29e627f67a06b065af8ea40462dbdb72cf74b522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caeb624a4ef708bddb96c3e0bc646994e6b285c7df7f4382cce2a38a1a8f8579"
  end

  depends_on "lua" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["CURSES_PACKAGE"] = "ncursesw"
    system "make", "OBJDIR=#{buildpath}/wg-build"
    bin.install "bin/wordgrinder-builtin-curses-release" => "wordgrinder"
    man1.install "bin/wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system bin/"wordgrinder", "--convert", "#{doc}/README.wg", testpath/"converted.txt"
    assert_path_exists testpath/"converted.txt"
  end
end
