class Rediseen < Formula
  desc "Start REST API service for Redis without writing a single line of code"
  homepage "https://github.com/XD-DENG/rediseen"
  url "https://github.com/XD-DENG/rediseen/archive/1.0.0.tar.gz"
  sha256 "50b60cdf3724ef7d4b526f5d5c9806a87d54c91010c336e398541f017a44b3f2"

  head do
    url "https://github.com/XD-DENG/rediseen.git"
  end
  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    system "#{bin}/#{name}", "version"
  end
end
