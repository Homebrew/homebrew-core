class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/1.2.0.tar.gz"
  sha256 "84c2db9e0ee00350e3c998d5666ed587a98bd4f2650a1166c7532cfffbb48815"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ENV["GOPROXY"] = "https://goproxy.cn"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
