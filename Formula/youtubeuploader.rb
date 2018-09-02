class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/18.12.tar.gz"
  sha256 "c76fa3c1a021d38a1faf6ba46479b11888bdc892bff1a7e8902a8b4c2dc5d875"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/porjo/youtubeuploader"
    path.install Dir["*"]
    cd path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-a", "-ldflags", "-s -X main.appVersion=#{version}", "-o", "#{bin}/youtubeuploader"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -v")
  end
end
