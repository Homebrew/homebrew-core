class Rsyncy < Formula
  include Language::Python::Virtualenv

  desc "Status/progress bar for rsync"
  homepage "https://github.com/laktak/rsyncy"
  url "https://github.com/laktak/rsyncy/archive/refs/tags/v0.2.0-1.tar.gz"
  sha256 "b2f1c0e49f63266b3a81b0c7925592a405770a3e1296040a106b503a85024b00"
  license "MIT"
  head "https://github.com/laktak/rsyncy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c11a0cdf7eac702a51d30f410f112d0edf259693d6cf8cd274ac9e64197ec3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9a1f343d7be0ab8f49f7cc6727e65cfb935aa3c89516ce153aeaff7bedbd112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a80c3c46367ecdedd9738fc9e01edffd2933336840a0fa5bc56aa5014d09c71"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bf555f6cf1e7a6e60dd3c599979f5d139811fa19c4d29f75bb046a99e9ba51f"
    sha256 cellar: :any_skip_relocation, ventura:        "a3fa1652e2e761ee53a01f84a97f8d707937d63f0312a910d650455b32420365"
    sha256 cellar: :any_skip_relocation, monterey:       "6aefd6c0a367401f4f25dc15fcbb231bc341ddfe74b293df0d3a1ec3a51d1cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e6798a85fda4efc7059b6085c3b52eff43963f1a34c500a854922a9162a8b7"
  end

  depends_on "python@3.12"
  depends_on "rsync"

  uses_from_macos "zlib"

  def install
    virtualenv_install_with_resources
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(/.*rsync.+version.*/, shell_output("#{bin}/rsyncy --version"))

    # test copy operation
    mkdir testpath/"a" do
      mkdir "foo"
      (testpath/"a/foo/one.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin/"rsyncy", "-r", testpath/"a/foo/", testpath/"a/bar/"
      assert_predicate testpath/"a/bar/one.txt", :exist?
    end
  end
end
