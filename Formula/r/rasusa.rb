class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/4.0.0.tar.gz"
  sha256 "cfbcb8db74d2675d8844c99a48877cb109cd25d2aa97fba3945ccbba07bc073e"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e490ba8f6e4b8ca4d8965e0b4ae6448a205d8bf462d13aac83890e4f35f8452b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23305294ff906613a194a85f77e5f1d4463fbc1ab37ff01e82ced0b57e53c0b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec81daba484e187053e985a64e91b7c3220e24d52db27774531f522ec775dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b403394e19b92b43b877d75fd5b560ae64c03fe528ab8b7ddfe25da366e7fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70e117cfe0638fa31b945ea99472d85b5c5a112a728852f138ad8849fa9aed38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654b1cd11beeafdf126f3501dd64e9a5c26de589fa05796d0265b91a67f28b69"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end
