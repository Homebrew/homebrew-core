class Rai < Formula
  desc "Run AI instructions directly from your terminal, scripts, and CI/CD pipelines"
  homepage "https://appmakes.github.io/Rai/"
  url "https://github.com/appmakes/Rai/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "13c5a46ef9a186ee8521e0781ca60ea9a9b1fb7c4ba4b6d0a888e551ec4226e6"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rai --version")
  end
end
