class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://github.com/rbspy/rbspy/archive/v0.3.2.tar.gz"
  sha256 "8250692165937e1060ab3c94f6d4742658873073ca08ee50f6d546c7b84807ff"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/rbspy -V")
    assert_includes output, "rbspy"
  end
end
