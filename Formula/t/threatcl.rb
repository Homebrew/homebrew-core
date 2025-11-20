class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "ae317b6f3220bd13185b7c816b062068c10fe04edc8b4173c89a2d4776676d36"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9af9b6dc8aacdf0b0e7b1987d9ab99bf0d5657bbc79e83ab225a06ee98bd4e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59871a71db5db2dacf6add5b20d02def9bae5068a182a08d13f4d55cb1c1c28c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db416e774cca545e46d4747a409685cb9fdea59191e423a9d903f6cf0c5201a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "256677c2a68ce86f610462b85ddf6b19ddb35f6114c13cc0d2ee31006772d924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80bc05904c70e1000408203d4961137815502d8cd4547789d194c0f092c7e07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c8b4fd1eb2be8a1e86cbc01dadf7f76c122232511e911bfdec293960f5cc44"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
