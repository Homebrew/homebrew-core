class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "54bb235dcfc34e24c48bd5bc1f2ac9b8a6f9eb7cf1d3b64c514ebbf6d34570f1"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c401e82a7bf9717dd233dfb7405489c18c2988bfbcc5b4aa3efdd634f8fe2418"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f40c2aa428ee40981f8e85db77c773fed9515cc3153cfff406790b40477d596"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "699d1f1dcd8ea5f4fac4e261ac2db4cfd8d4ab2ffddbe40a6273758afc5b54f9"
    sha256 cellar: :any_skip_relocation, ventura:        "16f26dd22dd385a9bf4b95559cd93ffcbb7238ffce062b818609cf3a3d753a13"
    sha256 cellar: :any_skip_relocation, monterey:       "0b39de8db8cc05be8aa129242450bf9d6ed08812ac1006a774a5eeb2f3871231"
    sha256 cellar: :any_skip_relocation, big_sur:        "beb5b2084df22b06d916ba86c397faa7bd876e90d85603050b9abc0c16332d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e0865a77d5a3601df13c303b11674d306589bf25d33e235a524e1d8b7ae7cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
