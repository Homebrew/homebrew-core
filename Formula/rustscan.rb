class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/2.0.0.tar.gz"
  sha256 "94e1a825b0b063e3134d2dfb2b8a047b7527aa5a0ecd83b9627aee0dab1a55e0"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "58250ffc55db4dffc1eaa2fbae4ec063dace9bbd85113de2a8d14bc592700c3d" => :catalina
    sha256 "95aa6188106c8d0f70926ad1e31fdfaa43957a53d51e99e51dfd2b55e50015e0" => :mojave
    sha256 "6b312149a1fd03b4e12fff33956d85b07deec6d0cee09f349ed0af25782884a5" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable -a 127.0.0.1")
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable -a 0.0.0.0")
  end
end
