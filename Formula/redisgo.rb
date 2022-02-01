# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Redisgo < Formula
  desc "为更好的管理/监控Redis而倾心打造~"
  homepage "https://github.com/liuzhuoling2011/RedisGo"
  url "https://github.com/liuzhuoling2011/RedisGo/releases/download/3.0.0/RedisGo-v3.0.0-mac-amd64.zip"
  sha256 "eae0ceeb1460e61b067eff95b282ae6b5077a079b07e8c093456da6e90247105"
  version "3.0.0"
  license ""

  # depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "mv ./RedisGo ./redisgo"
    bin.install "redisgo"
  end
end
