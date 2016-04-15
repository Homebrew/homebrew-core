class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites."
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/1.11.6-rbsec.tar.gz"
  version "1.11.6"
  sha256 "18932a78ad968dc5859b8cc72c84e64a46367887eb9302eaf13069bb9da1e08d"
  head "https://github.com/rbsec/sslscan.git"

  bottle do
    cellar :any
    sha256 "b885f2a0a26d764eb80634ffd3834738b498a355704f5f6303f365b4208ae2b2" => :el_capitan
    sha256 "90f200a5d92d4d2561a31474ca5a17b1014a1945203c9f670c027ef8b67139bd" => :yosemite
    sha256 "b74ae765db7d73449c4a9231bdb90554171befc13b60c6813bc7069acb039b5d" => :mavericks
  end

  depends_on "openssl"

  def install
    system "make"
    bin.install "sslscan"
    man1.install "sslscan.1"
  end

  test do
    system "#{bin}/sslscan", "google.com"
  end
end
