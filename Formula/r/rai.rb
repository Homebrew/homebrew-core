class Rai < Formula
  desc "Run AI instructions directly from your terminal, scripts, and CI/CD pipelines"
  homepage "https://appmakes.github.io/Rai/"
  url "https://github.com/appmakes/Rai/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "07184ea43c2f7408259ab28d6be864e37c8ccd469c7af09f353db1b1d5d3b4fa"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rai --version")
  end
end
