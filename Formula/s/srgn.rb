class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.13.1.tar.gz"
  sha256 "1300d0490a21988f5bdbdb291457c1ebfa1140a05c9c94b29a0df898dc383791"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94465753abb628908bced6a7008b8a28210c4bf4a8912ef4cb77bbc802db8ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69f8ac516cd4026b59070c52a7cc4b711c1bd8342bdef0a2add792d121ac69c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea0ec8e6b6c491d29decc1ee68187db93dfdcc3d7522db574b5d0c0adc2fd86d"
    sha256 cellar: :any_skip_relocation, sonoma:         "447d51aa62eabd08370e1bc52d50f886acd5124dcdc9f94fba88dcd1ec5f68e4"
    sha256 cellar: :any_skip_relocation, ventura:        "941d3709de9bfc0096e67afdab30fc6f82ecbde46eb39976c83823876ac19dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "2959bfcfc4c4b0f0d526038598de846be04a1047a741f8f6c309d7b40bb211c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "363eb438d088f65394a7ec6b9475716eb19c7951c60e2e82a2c7ea31628f26a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
