class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "6e33bfb8c4b8fc741a736b596342797d82e87d4335cc3932dffacce16c4197b8"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b21573e8b1042eb2a35d1e52d57fc6768d61124ee5dba92a2dc97cf90340dd20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4dce237dc274591c49739d57612457fb770af8129413670f97bc8d7f77a83470"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0d317ba22956f358501fbe9cdd94bc597a646c7683f09b5de61bbc7e3b6c1dd"
    sha256 cellar: :any,                 arm64_linux:       "1ac80ce1fd44b855773bc1ddde03a242cb05190b66d12f20e40ccb0a5150a2ed"
    sha256 cellar: :any,                 x86_64_linux:      "8746dcffc1b00c6acb424deccae820974ea82172e25f0ea8a23ec5b3494f482c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block downloads fonts.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
