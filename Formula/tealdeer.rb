class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.2.0.tar.gz"
  sha256 "5cf286059b823501d05da445b9b7a609ec2da91d711d990df76397f79d800c52"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc8608562bba3aaccdfa5c15003e98bb0b02892e5bdb17436d61051b02b65210" => :catalina
    sha256 "964fd2fb421a2454648d1be9d2ce8fbab00fedca36a7e964f5da516406638aee" => :mojave
    sha256 "ff092cd4796f47c7d62bccddc8f64d1afb18e94366568880187b8be0bb142974" => :high_sierra
    sha256 "e6a03bd85487c6d11f7558e30bd736fe96527803798c21beecf3ee4069c0f855" => :sierra
  end

  depends_on "rust" => :build

  conflicts_with "tldr", :because => "both install `tldr` binaries"

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
    bash_completion.install "bash_tealdeer"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
