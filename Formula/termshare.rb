require "language/go"

class Termshare < Formula
  desc "Interactive or view-only terminal sharing via client or web"
  homepage "https://github.com/progrium/termshare"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"
  revision 1
  head "https://github.com/progrium/termshare.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4dd298c36b89e861cbcbc96746c8174c034ee8fbe1878973e8cee862659fa65a" => :catalina
    sha256 "bb86a376d3ec20e2ccfe1359f90f394b515dedd9d2015a8e0e753704ffbefbdf" => :mojave
    sha256 "9f20373c2b495c9308ed1b798d1d928e06318cbe996093b97e0126b038e76085" => :high_sierra
    sha256 "5d883c6747f478ab161ca648923a7397a782f437bb59d660df6a252b21f62e99" => :sierra
    sha256 "c540732aab70ec29b60459c19bb4ee55c0584b3a63476473219a115d2ec380af" => :el_capitan
    sha256 "c3b9c2784b02536ce97a2a3b3a205314e7ada8e727ac60b54577d933a04aa808" => :yosemite
    sha256 "aa9131a7eae6efe7e7d3bac1e73711f7bfe52f1dd246389bdbb137c70c815310" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "7553b97266dcbbf78298bd1a2b12d9c9aaae5f40"
  end

  go_resource "github.com/heroku/hk" do
    url "https://github.com/heroku/hk.git",
        :revision => "406190e9c93802fb0a49b5c09611790aee05c491"
  end

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
        :revision => "f7ee69f31298ecbe5d2b349c711e2547a617d398"
  end

  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
        :revision => "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/progrium/termshare"
    path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      # https://github.com/progrium/termshare/issues/9
      inreplace "termshare.go", "code.google.com/p/go.net/websocket",
                                "golang.org/x/net/websocket"
      system "go", "build", "-o", bin/"termshare"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termshare -v")
  end
end
