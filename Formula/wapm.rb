class Wapm < Formula
  desc "📦 WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/0.4.3.tar.gz"
  sha256 "0a4057217a539a013549fd2bf3913bff28f0ec01d6606ebc278c2057c6e268a2"
  head "https://github.com/wasmerio/wapm-cli.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    help_first_line = shell_output("#{bin}/wapm -h 2> /dev/null").split("\n").first
    assert_equal "wapm-cli #{version}", help_first_line
  end
end
