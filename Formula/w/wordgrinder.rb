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
    sha256 cellar: :any,                 arm64_tahoe:    "c547d9112c5e07a735c6adb27d6df7c5f82005f5cfd095d0d4beeafd48ced0fd"
    sha256 cellar: :any,                 arm64_sequoia:  "281cb8b0ac7c49861af74607ffa9ff36aed7f7899a46bbd18d686cf958c90c1f"
    sha256 cellar: :any,                 arm64_sonoma:   "01e1ab04fb507afd5e62ddfee96e629ae7405671a3a6ad107eca9f30771b76b8"
    sha256 cellar: :any,                 arm64_ventura:  "b89498bd5c54678e5460ccf146084abdde90853f465f17775657298fe1ba5c91"
    sha256 cellar: :any,                 arm64_monterey: "3eb4bf8cff526d9a6e6c9e285ba2a63879eb157a6ba091dff6be7ad49da749b3"
    sha256 cellar: :any,                 arm64_big_sur:  "370093b3705f72a5d6b87bacd2e64e229f3d6ac82e52e92fe147c037d65f210b"
    sha256 cellar: :any,                 sonoma:         "47819e0bc05f370758760d534a0f3e5012ad02abad4ec78427f4191439888211"
    sha256 cellar: :any,                 ventura:        "1a575a0eff9cd74e4a48a4ede1694349892f5a07c089d9e5bd1be74560eaf5ac"
    sha256 cellar: :any,                 monterey:       "2ab17d2541132790b1b134a5d33e5e9178ce96b7afeadf28819a9694f87712da"
    sha256 cellar: :any,                 big_sur:        "d2cb8d569e0a7a02abae8deb32adf8a564042cfd6cddaeef4bc1dc16ab05e53b"
    sha256 cellar: :any,                 catalina:       "e084da6193fd984ac541e7c21044f80927b60b85ab69512d3824255be1c54d17"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "761d5901adbb5d8c732f4b1cadf91c9902fe0d30db0188a93b1648efe1a0b886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fdfa2bd3da72697fbd54cc93a8bc59b2c3afc3ddbfd55a46cde0e557011ca4"
  end

  depends_on "lua" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses"

  uses_from_macos "zlib"

  def install
    ENV["CURSES_PACKAGE"] = "ncursesw"
    system "make", "OBJDIR=#{buildpath}/wg-build"
    bin.install "bin/wordgrinder-builtin-curses-release" => "wordgrinder"
    man1.install "bin/wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system bin/"wordgrinder", "--convert", "#{doc}/README.wg", "#{testpath}/converted.txt"
    assert_path_exists testpath/"converted.txt"
  end
end
