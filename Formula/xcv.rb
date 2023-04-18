class Xcv < Formula
  desc "Cut, copy and paste files with Bash"
  homepage "https://github.com/busterc/xcv"
  url "https://github.com/busterc/xcv/archive/v1.0.1.tar.gz"
  sha256 "f2898f78bb05f4334073adb8cdb36de0f91869636a7770c8e955cee8758c0644"
  head "https://github.com/busterc/xcv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a715d85b4b84704d9f4f01949e017e0ed875e812b2c200ce7ba75102f8fb9769"
  end

  def install
    bin.install "xcv"
  end

  test do
    system "#{bin}/xcv"
  end
end
