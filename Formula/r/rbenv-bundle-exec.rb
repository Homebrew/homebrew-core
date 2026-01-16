class RbenvBundleExec < Formula
  desc "Integrate rbenv and bundler"
  homepage "https://github.com/maljub01/rbenv-bundle-exec"
  url "https://github.com/maljub01/rbenv-bundle-exec/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2da08cbb1d8edecd1bcf68005d30e853f6f948c54ddb07bada67762032445cf3"
  license "MIT"
  revision 1
  head "https://github.com/maljub01/rbenv-bundle-exec.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8c0d3d96110c571151ccc1500854047f47bd9f2b372bc65b70b0bde9f7a4465f"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundle-exec.bash", shell_output("rbenv hooks exec")
  end
end
