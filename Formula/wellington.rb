require "language/go"

class Wellington < Formula
  desc "Project-focused tool to manage Sass and spriting"
  homepage "https://getwt.io/"
  url "https://github.com/wellington/wellington/archive/v1.0.4.tar.gz"
  sha256 "ef92d6c2b11fe36f66b88612e7a9cfff3ea6f81f29f4c21481d358f474a191d6"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df25c2ccd2a972ba8e208168552d97fab66aedda36eb34df7b52b16f8db0d386" => :high_sierra
    sha256 "a0ba1b9d9b495bf840140087276b501c0458b0d9d64a7bd83d19208e5787a569" => :sierra
    sha256 "f681adb615a82377c1855000ac57c26c7403df8f8a1371646630afaddb922e63" => :el_capitan
    sha256 "224a5a7d40b14cbd89e6cec80c73fd775aaf660c94fba53d651b70aab56524e9" => :yosemite
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        :revision => "f09c4662a0bd6bd8943ac7b4931e185df9471da4"
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/wellington/wellington"
    dir.install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd dir do
      system "go", "build", "-ldflags",
             "-X github.com/wellington/wellington/version.Version=#{version}",
             "-o", bin/"wt", "wt/main.go"
      prefix.install_metafiles
    end
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<~EOS
      /* line 1, stdin */
      div p {
        color: red; }
    EOS
    assert_equal expected, pipe_output("#{bin}/wt --comment", s, 0)
  end
end
