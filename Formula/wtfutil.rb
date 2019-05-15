class Wtfutil < Formula
  desc "Terminal based search engine for bash commands"
  homepage "The personal information dashboard for your terminal."
  url "https://github.com/wtfutil/wtf/archive/v0.10.2.tar.gz"
  sha256 "7ed8c63bd7126b39b35026bf25df3ebd4404aa804c54eb47b6fa04c6fe1e478b"

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
