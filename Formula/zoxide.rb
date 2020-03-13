class Zoxide < Formula
  desc "Fast cd command that learns your habits"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.2.0.tar.gz"
  sha256 "628c394d7b5031cf986c5a8b24083dc5941a21d7491ae916684c3322ac748318"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "false"
  end
end
