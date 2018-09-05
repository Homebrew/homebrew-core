class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.15.0.tar.gz"
  sha256 "6e5eafdf16e18bcb5d2a6a448307b021f47149e480a01d6cfb4454e923623d3f"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c2dc53809a93069890fd09c539e9ccb32cdaa6a56b6ec8af66322b87fb95abc" => :mojave
    sha256 "223b1b559d163410cae027526f5c6de0c7f9ac766bafbf77b7abf1e4a2f3e83a" => :high_sierra
    sha256 "97fec16060a7e644402ea8e24fe57aa0dcf4a8e31b6505dc8f57574fd1b57f2c" => :sierra
    sha256 "b97a438ef61327a2c876a934417d61f0cebc710520f0a17eb123217b57a13d2f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
