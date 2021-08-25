class RbenvBundleExec < Formula
  desc "Integrate rbenv and bundler"
  homepage "https://github.com/maljub01/rbenv-bundle-exec"
  url "https://github.com/maljub01/rbenv-bundle-exec/archive/v1.0.0.tar.gz"
  sha256 "2da08cbb1d8edecd1bcf68005d30e853f6f948c54ddb07bada67762032445cf3"
  license "MIT"
  revision 1
  head "https://github.com/maljub01/rbenv-bundle-exec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "025058645a7236199e0b2a4083ab8a1f540d48026ad69d3607e3f7abf07e61e9"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundle-exec.bash", shell_output("rbenv hooks exec")
  end
end
