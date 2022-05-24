class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.5.tar.gz"
  sha256 "06906324bc510698651e57b1dfe9a28301ccbdd509f079bf09ce7f6d2f2fad2b"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89313c19726c79ac75f6622ed16ecc6f7689bca88cdc03d02021f7494a0bccec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17b3094ed19f8840086269625285ac9af611a365e635611f309920bf4159fae4"
    sha256 cellar: :any_skip_relocation, monterey:       "5e38b194a6f24f7bfd2e713b53e1c4812e68b46693cc2d38e785c3e6a89b558d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9b66868892aa0363521d81de5659296ce1859a3e92a68a7acd78069e297ec20"
    sha256 cellar: :any_skip_relocation, catalina:       "a52b9c9855368cb69404ffe1a42e0395dca583fd5a4421d8fbe09b0a5bc425ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3324c8003f024ef0fc77602781bf9ef4933390671add8905098996389da8a5d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
