class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/2.2.2.tar.gz"
  sha256 "f764d257fcdedcf08b8cb18bd4e93ffab8a788785e7161feb16ea1f2d4f30361"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8a82381026f260b8e9fbd877895e6b98014d0ee57dd02408bd361448e6f9f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d85950d24d6d39fdbe673927b499994c505bdf6bb1cec55a7f76bbe1e23ad46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d635745b1cde72db516a3603ebcc47ffb7f05c9019d81f044ff6cd4377c3905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff0b1250b016282ba37d89b1799cbc24cb6e957a19f8ed2d4be90f4d9f439f45"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e3c75c6178c30ca0c85a637eea94af66492574d2c77c311d470e0e9b870892"
    sha256 cellar: :any_skip_relocation, ventura:       "40ad9eecb61d0e9fcab53e2211b2e45c50050005eeeb755882988643b5fc77e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17dee28a35d9afd606bbe9516aa79b4cf764a4a4c0501d3a46804c42dee7a448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa6cb47cd34bde6a923d4b454dde2be0d30b1bd02a8aa8b12040a413f963089"
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
