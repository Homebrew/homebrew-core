class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.0.0.tar.gz"
  sha256 "9d9712e1b1a17c23793e81691ca6f8e4d45b7fd77efa300261e066c2d254705b"

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
