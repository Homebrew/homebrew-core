class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/f1/5e/a061c609543bda6a154d8466f38c08d57c3aa042dee0dd8c24647736f90b/translate-toolkit-3.9.0.tar.gz"
  sha256 "85c239ddef769d814fa69bae0651d0849545538fcbfb09347ea503bbc406a115"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e66f3ff228786606615de73b31a62d7f6c1d27fadd4a16323299d931186e082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd2461d7e5ff210113f96edce876a6b33ef3966a5711c489a5c253961c36670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eca446c7983c8b281a23152494fab915bdb25b71bf51399fd5535e0c9e23b22"
    sha256 cellar: :any_skip_relocation, ventura:        "91e552d2b54f4e89acec877726b3ec7e5935d98c9cd59ea13c2155f150f360f0"
    sha256 cellar: :any_skip_relocation, monterey:       "9f1c698835f57b11e13aeb6f1bbfca47fc18d5d799a3eb8410bdbc13b048aff8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0010ef8c2a7ad085c6872c3a219bfe320176339f4601d0f361b48cb9763fa06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16fda34dcbc5708f58002495d9e86813d31f681abf9fdd6bba45a47be83d0262"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
