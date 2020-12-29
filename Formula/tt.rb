class Tt < Formula
  desc "Terminal based typing test"
  homepage "https://github.com/lemnos/tt"
  url "https://github.com/lemnos/tt/archive/0.0.1.tar.gz"
  sha256 "007ccfabae069035bf01274b482c84af36b5f0588066da1cd784e62caa461f1e"
  license "MIT"
  head "https://github.com/lemnos/tt.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tt"
  end

  test do
    assert_match(/nord/, shell_output("#{bin}/tt -list themes"))
  end
end
