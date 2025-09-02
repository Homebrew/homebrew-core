class Vecto < Formula
  desc "A powerful personal note management system with semantic search capabilities"
  homepage "https://github.com/yswa-var/Vectoria"
  url "https://github.com/yswa-var/Vectoria/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ef85f4570b5c1a0d9569794c6cbc35e3acc652f010327d9d771f6037fb6e2087"
  license "MIT"
  head "https://github.com/yswa-var/Vectoria.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    system "#{bin}/vecto", "--version"
  end
end


