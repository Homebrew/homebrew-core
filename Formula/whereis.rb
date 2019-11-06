class Whereis < Formula
  desc "Whereis that works! for macOS (and linux)"
  homepage "https://github.com/WestleyR/whereis"
  url "https://github.com/WestleyR/whereis/archive/v1.0.0.tar.gz"
  sha256 "ea140364f939f96c1d5971d7a83f60bd0f6000f5a07f4a0efc5e4692cebf70f8"

  # depends_on "cmake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/whereis", "sh"
  end
end

