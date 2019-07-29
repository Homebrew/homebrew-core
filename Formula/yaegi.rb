class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.0.4.tar.gz"
  sha256 "007d887814361b8124b9c9030dfc1b8819a0ed91c91dd3b5a8580c419c589ad7"
  head "https://github.com/containous/yaegi.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/containous/yaegi"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
