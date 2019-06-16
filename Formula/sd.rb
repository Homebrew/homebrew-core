class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/0.6.2.tar.gz"
  sha256 "376cd67a05b09f490b62bd8074a8857bf88a8fd473e51743ba23c57a26b825a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "03a4b3371c85c306c17cfa3063fa6970fee018c84c04571dd8083b91ef03e6a1" => :mojave
    sha256 "8bdcaf741db44429c93ac6fcf0b247de0a9909c1dbd50d0ed919d0a7a6fd15f8" => :high_sierra
    sha256 "386f20d39aef8e0b41fb952f05b988551a20ccd6a4c63bf5e056d70d5913c8e3" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
