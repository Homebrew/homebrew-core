require "language/go"

class Termshare < Formula
  desc "Interactive or view-only terminal sharing via client or web"
  homepage "https://github.com/progrium/termshare"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/progrium/termshare.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4614ca141bf850bcf6d6a79e2ae20aea42e09c8ee4ce448a33132a6de1a7c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a187c25803562d3116f85b629b1957e56a335a5345cce0bd4a5a9b798e064d"
    sha256 cellar: :any_skip_relocation, monterey:       "d51e1af4004ca47642d84f8749fe1cafa4c5343e64d6568e7e871eccab973978"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fdfd431495e9ec1131134560723d80db8b95f72d3ba47725294914c96f3490b"
    sha256 cellar: :any_skip_relocation, catalina:       "4dd298c36b89e861cbcbc96746c8174c034ee8fbe1878973e8cee862659fa65a"
    sha256 cellar: :any_skip_relocation, mojave:         "bb86a376d3ec20e2ccfe1359f90f394b515dedd9d2015a8e0e753704ffbefbdf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9f20373c2b495c9308ed1b798d1d928e06318cbe996093b97e0126b038e76085"
    sha256 cellar: :any_skip_relocation, sierra:         "5d883c6747f478ab161ca648923a7397a782f437bb59d660df6a252b21f62e99"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c540732aab70ec29b60459c19bb4ee55c0584b3a63476473219a115d2ec380af"
    sha256 cellar: :any_skip_relocation, yosemite:       "c3b9c2784b02536ce97a2a3b3a205314e7ada8e727ac60b54577d933a04aa808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e6403e077b20a2b771cc2d7e20407fc0f121688182ea2c6c660dd42f9cf118c"
  end

  depends_on "go" => :build

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        revision: "7553b97266dcbbf78298bd1a2b12d9c9aaae5f40"
  end

  go_resource "github.com/heroku/hk" do
    url "https://github.com/heroku/hk.git",
        revision: "406190e9c93802fb0a49b5c09611790aee05c491"
  end

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
        revision: "f7ee69f31298ecbe5d2b349c711e2547a617d398"
  end

  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
        revision: "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
