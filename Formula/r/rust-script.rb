class RustScript < Formula
  desc "Run Rust files and expressions as scripts without any setup or compilation step"
  homepage "https://rust-script.org"
  url "https://github.com/fornwall/rust-script/archive/refs/tags/0.36.0.tar.gz"
  sha256 "9b6d04ad4dd34838c1b55a8ec4b69e8d7f3008a67d85ef1c35b49502c359b6d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48cb1216ddc8cd608e0c77e1c02c26bd97011c332f4eb7cc98c9d2249db73133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62c6d7194f24ae539710d71a0d704f59d0b269e72ee975b089387562846ca9d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f9f6e9c736740c28e4122afb9b7fb20bd5377ac23385961e15b40327f8442ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69adfb1fb154780d073e987287b51623cb7b00f6d0a15b9ce11814788c914685"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed6eadc0ae46bbc151c3a4ba63727c66b8d69f71b75639487891a97cfee9431"
    sha256 cellar: :any_skip_relocation, ventura:       "dcffce4689635b8171651084f751de12468ec162853205dca598e86bc427f33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd8b102839fff6efe6d8dfb8353de1f008edc51f0f7eca5907b4589c64b3140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a621299898caf1365fe29b39303f41b4becbce8e6450db1a787b07e6de258307"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "Hello, world!", shell_output("#{bin}/rust-script -e 'println!(\"Hello, world!\")'").strip
  end
end
