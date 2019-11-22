class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.2.0.tar.gz"
  sha256 "5cf286059b823501d05da445b9b7a609ec2da91d711d990df76397f79d800c52"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "778935472a63f1b04b68597158467aa4ccf4633592aa6b9a781634bd4774c877" => :catalina
    sha256 "1c8932dac2f578a4b64d472a6fce712309c998b05128a77e6fb4be4353112bc5" => :mojave
    sha256 "b9c9181ba84b47b2dadaf49bfc9e8726273a071615e8229ed646181d4cbe5a49" => :high_sierra
  end

  depends_on "rust" => :build

  conflicts_with "tldr", :because => "both install `tldr` binaries"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    bash_completion.install "bash_tealdeer"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
