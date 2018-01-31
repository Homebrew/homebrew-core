class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://github.com/rbspy/rbspy"
  url "https://github.com/rbspy/rbspy/archive/v0.1.8.tar.gz"
  sha256 "87f759acd9d660178737b9f24cc07f0113a81a9fffc1604bae2c756d7f4d815b"

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/rbspy"
  end

  test do
    output = shell_output("#{bin}/rbspy -V")
    assert_includes output, "rbspy"
  end
end
