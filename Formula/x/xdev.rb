class Xdev < Formula
  desc "Your all-in-one developer toolkit"
  homepage "https://github.com/ahelmy/xdev"
  url "https://github.com/ahelmy/xdev/archive/refs/tags/v0.0.1-pre.tar.gz"
  sha256 "1ee3f854b46f47dd282a29664bedb2f111fcfd366141c5b6ca819087876bbed5"
  license "Apache-2.0"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ahelmy/xdev"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"xdev"
    end
  end

  test do
    system "#{bin}/xdev" "-h"
  end
end