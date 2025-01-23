class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.3.tar.gz"
  sha256 "5a40724e7eb2a20db279cbc87f971ae67a9af5ea04fd2aa0126d3c6c31c9e09a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "762a7fd24b98277e00d3430a120351d86928f72704ffbb0a71e0b917e200cd45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5aee13a897c5aaa63bfc9c508c7b8dddfe6cbd01eaaf25a65b5f0b085b6b2df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b81f37c90efe52189da9d9372724f80c4d1da38e531caf21b99fd63bf6191aec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c117322f51dfffb4c572dde0230840705b164a4cd054f6ef083ee73bc00f207a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7ea2af806cddf5889508721f42c245c732dde861279a397ac54f71d91787b3f"
    sha256 cellar: :any_skip_relocation, ventura:        "10272c254cdb40831f439534d5e98eaf572735b595b9845121d51f3ec0134eef"
    sha256 cellar: :any_skip_relocation, monterey:       "da2ec5b9d85afaa959b92983f417b084a6ffcf0150c98a9acf07420e0ce79aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3254ac904f83e9ec62f1bd9ae09a01133b0e2089e5cf872480fac35833971f"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end
