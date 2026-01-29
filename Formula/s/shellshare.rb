class Shellshare < Formula
  include Language::Python::Shebang

  desc "Live Terminal Broadcast"
  homepage "https://github.com/vitorbaptista/shellshare"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bc56d21bcef73aa2c40cd689c84cf8a0c8d2682e76b1f48e8f7ff53b7325f72e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba4ddd42e53194b47c2128991ff4bc17e5eace09dd41819771fe3bd9fd02f54f"
  end

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "public/bin/shellshare"
    bin.install "public/bin/shellshare"
  end

  test do
    system bin/"shellshare", "-v"
  end
end
