class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.10.14.tar.gz"
  sha256 "fd7e7298f51dfb9a12e50e8bfe098a467f5deb97552c9627be00ecfc928b7e81"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ded9b728accbd81f1b20925dac01089db43a350707576d26d692d7b21862bf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60348b26a00d0a7598007649588055320e9150919639da58fb25b67cc07fecc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3a982439555132e0a01768bc5e7e2f11b8421f3bec970d061e064db72f8db6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f46be77113d038693f9f5c057f028046051733005fab0745f0a25d645654fde4"
    sha256 cellar: :any_skip_relocation, ventura:       "00ffefe64c7ef16521b51576170d1183d5bb22e9ae4e4f7e9882225004baeec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f87e29df837b0ff09be4acc6fad11ddc19a8fd3d13c32d3cff23341811b994b"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
