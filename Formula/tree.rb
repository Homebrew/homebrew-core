class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.0.4.tgz"
  sha256 "b0ea92197849579a3f09a50dbefc3d4708caf555d304a830e16e20b73b4ffa74"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58c55a2893660f39cd4d4942ac8a409ef7fb83c5042773cefce37fbe0e0c300c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8eb457cd23554cbee29e9527287eb482a995d4b82a96e70c20424ea992394b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff0bfbe9dcc7108e646741181900f1947d52dc60aee229fc9d834bee0ae3ac80"
    sha256 cellar: :any_skip_relocation, ventura:        "276d130d97d33a4854b4a60c6fb25166dd0d1614b3d9bdea282b29ff0a4a5750"
    sha256 cellar: :any_skip_relocation, monterey:       "189103af15d87e1f5fa07a47d4050d070629e99f299bad5dd9ed54c4289fdb73"
    sha256 cellar: :any_skip_relocation, big_sur:        "c96432f421c19d06bec2a01e0d789334a01db4c04a21ae058cb745203ea75f79"
    sha256 cellar: :any_skip_relocation, catalina:       "f58be945558f3c5486581f71aeba7d9599227bfdd1c06651b3d3639cb655ecbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8431d98c7898d6bab60b9d6a221f9cb694e35ce9f3ef0e094d6939eeb11ac2e"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o list.o hash.o color.o file.o filter.o info.o unix.o xml.o json.o html.o strverscmp.o"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
