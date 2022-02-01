class Redisgo < Formula
  desc "为更好的管理/监控Redis而倾心打造~"
  homepage "https://github.com/liuzhuoling2011/RedisGo"
  url "https://github.com/liuzhuoling2011/RedisGo/releases/download/3.0.0/RedisGo-v3.0.0-mac-amd64.zip"
  version "3.0.0"
  sha256 "eae0ceeb1460e61b067eff95b282ae6b5077a079b07e8c093456da6e90247105"
  license ""

  def install
    File.rename("./RedisGo", "./redisgo")
    bin.install "redisgo"
  end
end
