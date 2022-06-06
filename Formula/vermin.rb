class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.0.tar.gz"
  sha256 "984773ed6af60329e700b39c58b7584032acbc908a00b5a76d1ce5468c825c70"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78b0ba9a707cef99046629273e048e95bdb41a5f2d58ee343d3088b509c3dc61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b0ba9a707cef99046629273e048e95bdb41a5f2d58ee343d3088b509c3dc61"
    sha256 cellar: :any_skip_relocation, monterey:       "4a31f6d451c7be3fca256f08212b838d348ca520c07e64c6921834fc4409f154"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a31f6d451c7be3fca256f08212b838d348ca520c07e64c6921834fc4409f154"
    sha256 cellar: :any_skip_relocation, catalina:       "4a31f6d451c7be3fca256f08212b838d348ca520c07e64c6921834fc4409f154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9958a00ae57d114cbe0e689972e77df8074f5cc208de1a247a16f4e8566f533"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/"lib/python3.10/site-packages/vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
