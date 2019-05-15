class Wtfutil < Formula
  desc "Terminal based search engine for bash commands"
  homepage "The personal information dashboard for your terminal."
  url "https://github.com/wtfutil/wtf/archive/v0.10.1.tar.gz"
  sha256 "84a62cde581680d236eb1fe89df28feead1303d1c7bd2d2e07744bbfd17c7762"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtf"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/wtf", "-p", "brew"
  end
end
