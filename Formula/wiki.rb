require "language/go"

class Wiki < Formula
  desc "Fetch summaries from MediaWiki wikis, like Wikipedia"
  homepage "https://github.com/walle/wiki"
  url "https://github.com/walle/wiki/archive/1.4.0.tar.gz"
  sha256 "b9adb27485feba68574e3abf5564577f2fcec1bf2176fc8f80b09b6f8ca6ffff"

  bottle do
    cellar :any_skip_relocation
    sha256 "97fff58adf33b41ca00e4112ef099a76c333cf2fb501a85ce155a19284b47387" => :catalina
    sha256 "c2356b595d2c4b9a6ade9f569b0186de56c016121cb28c5e525353ad3b74c7c0" => :mojave
    sha256 "b659c9bc28a5468e61a7af026f20fe8a9233b852e1165e5d900755db68fa85f6" => :high_sierra
    sha256 "0f3302cb5063486d6cb1beb1a25c771b50c03f0318f05e7d3520b1a2d05a445b" => :sierra
    sha256 "6e6d9036b7943ef08cbf92c5aec72b214599aa83bd0a038f4d7a0d19a90a70b0" => :el_capitan
    sha256 "b7f224cc011a63259a7ef24b2709a4fb3ba053b15f1861a6c3f03d29925251f8" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "40e4aedc8fabf8c23e040057540867186712faa5"
  end

  def install
    ENV["GOPATH"] = buildpath
    wikipath = buildpath/"src/github.com/walle/wiki"
    wikipath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/walle/wiki" do
      system "go", "build", "-o", "build/wiki", "cmd/wiki/main.go"
      bin.install "build/wiki"
      man1.install "_doc/wiki.1"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Read more: https://en.wikipedia.org/wiki/Go", shell_output("#{bin}/wiki golang")
  end
end
