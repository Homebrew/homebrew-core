class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "3f556b33fee8f2c16076e26a6573651599126349b48373e2ca87e74bcff7a2f7"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c663e7c1d82304c6ff9a5f01d74e074cc21bdaf8aa0a2a2e78ceea69f798dda4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb439c7fb779e668a5a43f8e72f02f4335b0c1e769506641a4e6dba98c72f029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba7461c89f21d747c6e6ab82c87288e41db18bee89fb9d870ce142e8949dc73"
    sha256 cellar: :any_skip_relocation, sonoma:        "65019618369eceffef536051b61569b4a0ea6e8f01529aa044b01ed1aa42de67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d28a81c239b1d3ed101b40c78ee967ad9664439870783ea5342b0de6330ed892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10501b62fecd136bb4a34f0fda34707237850745298a10d0e1fff85a310bc96b"
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
