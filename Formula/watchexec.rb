class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.1.tar.gz"
  sha256 "22937d69897b21c9dd24c6c1db59859689ff81ea4a8d5fe11b901fa285d005c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dcd9d26314e075f4e135479456bfa5e8ffad447083857fb327ef8f4f4e1b83e" => :sierra
    sha256 "f747b55ff6c1119e66a7b4396475c93bf2126fe177c2ef0f4d28831755b70eb9" => :el_capitan
    sha256 "d687076db8729ed6a911f1afea51e93c6d10b14ea702404179303215f527c0d3" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/watchexec"
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
