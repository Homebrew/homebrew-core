class Tccutil < Formula
  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.13.tar.gz"
  sha256 "b0e3f660857426372588b0f659056a059ccbd35a4c91538c75671d960cb91030"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "27033a9fedb26e4ea0087263ed08c2ab7136ca8258ac08f2fd0e6511d217c481"
  end

  depends_on :macos
  depends_on "python@3.11"

  def python
    deps.first.to_formula
  end

  def install
    prefix.install_metafiles
    libexec.install "tccutil.py"
    (bin/"tccutil").write_env_script libexec/"tccutil.py", PATH: "#{python.opt_libexec}/bin:$PATH"
  end

  test do
    ENV.prepend_path "PATH", python.opt_libexec/"bin"
    system "#{bin}/tccutil", "--help"
  end
end
